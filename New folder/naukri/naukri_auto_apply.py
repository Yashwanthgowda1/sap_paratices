import time
import os
import sys
import subprocess
import traceback
from datetime import datetime
from dotenv import load_dotenv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import (
    NoSuchElementException, TimeoutException,
    ElementClickInterceptedException, StaleElementReferenceException,
    WebDriverException,
)

sys.stdout.reconfigure(line_buffering=True)

load_dotenv()

EMAIL    = os.getenv("NAUKRI_EMAIL")
PASSWORD = os.getenv("NAUKRI_PASSWORD")

SEARCH_QUERIES        = ["SDET", "Automation Testing", "Test Automation Engineer", "QA Automation"]
MAX_APPLIES_PER_QUERY = 10

LOG_FILE    = os.path.join(os.path.dirname(os.path.abspath(__file__)), "naukri_apply_log.txt")
SS_DIR      = os.path.join(os.path.dirname(os.path.abspath(__file__)), "screenshots")
HEAL_RETRIES = 3   # how many times self-heal will retry a failed action


def log(msg):
    ts = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(line + "\n")


def screenshot(driver, label=""):
    """Save a timestamped screenshot for debugging."""
    os.makedirs(SS_DIR, exist_ok=True)
    ts   = datetime.now().strftime("%H%M%S")
    name = f"{ts}_{label}.png" if label else f"{ts}.png"
    path = os.path.join(SS_DIR, name)
    try:
        driver.save_screenshot(path)
        log(f"    [screenshot] {path}")
    except Exception:
        pass


# ─────────────────────────────────────────────────────────────
#  SELF-HEALING CLICK
#  Tries up to HEAL_RETRIES times with progressive strategies.
# ─────────────────────────────────────────────────────────────
def heal_click(driver, element, label="element"):
    """Click an element with automatic self-healing on failure.

    Strategy order:
      1. Regular Selenium click
      2. Dismiss overlay + JS scrollIntoView + JS click
      3. dispatchEvent MouseEvent
      4. ActionChains move_to_element + click
    """
    strategies = [
        lambda el: el.click(),
        lambda el: (
            dismiss_overlay(driver),
            driver.execute_script("arguments[0].scrollIntoView({block:'center'});", el),
            time.sleep(0.3),
            driver.execute_script("arguments[0].click();", el),
        ),
        lambda el: driver.execute_script(
            "arguments[0].dispatchEvent(new MouseEvent('click',{bubbles:true,cancelable:true,view:window}));", el
        ),
        lambda el: __import__("selenium").webdriver.ActionChains(driver).move_to_element(el).click().perform(),
    ]

    last_exc = None
    for attempt, strategy in enumerate(strategies, 1):
        try:
            strategy(element)
            if attempt > 1:
                log(f"    [heal] '{label}' clicked on attempt {attempt}")
            return True
        except (ElementClickInterceptedException, StaleElementReferenceException,
                WebDriverException) as exc:
            last_exc = exc
            log(f"    [heal] attempt {attempt} failed for '{label}': {type(exc).__name__}")
            screenshot(driver, f"heal_fail_{label}_{attempt}")
            time.sleep(0.5)

    log(f"    [heal] all strategies failed for '{label}': {last_exc}")
    return False


def heal_find(driver, xpaths, label="element", timeout=8):
    """Find an element by trying multiple XPaths; waits up to `timeout` s total."""
    deadline = time.time() + timeout
    while time.time() < deadline:
        for xp in xpaths:
            els = driver.find_elements(By.XPATH, xp)
            if els:
                try:
                    if els[0].is_displayed():
                        return els[0]
                except StaleElementReferenceException:
                    pass
        time.sleep(0.4)
    log(f"    [heal] could not find '{label}' after {timeout}s")
    return None


# ─────────────────────────────────────────────────────────────
#  DRIVER / LOGIN / OVERLAY
# ─────────────────────────────────────────────────────────────
def init_driver():
    options = webdriver.ChromeOptions()
    options.add_argument("--start-maximized")
    options.add_argument("--disable-notifications")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option("useAutomationExtension", False)
    return webdriver.Chrome(options=options)


def login(driver, wait):
    log("[*] Logging in...")
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)
    wait.until(EC.presence_of_element_located((By.ID, "usernameField"))).send_keys(EMAIL)
    driver.find_element(By.ID, "passwordField").send_keys(PASSWORD)
    driver.find_element(By.XPATH, "//button[@type='submit']").click()
    time.sleep(4)
    log("[+] Logged in.")


def dismiss_overlay(driver):
    """Inject persistent CSS + MutationObserver to permanently kill chatbot overlay."""
    driver.execute_script("""
        if (!document.getElementById('_kill_overlay_style')) {
            var style = document.createElement('style');
            style.id = '_kill_overlay_style';
            style.textContent = `
                .chatbot_Overlay, [class*="chatbot_Overlay"],
                [class*="chatbot"], [id*="chatbot"] {
                    display:none !important;
                    pointer-events:none !important;
                    z-index:-9999 !important;
                    visibility:hidden !important;
                }`;
            document.head.appendChild(style);
        }
        document.querySelectorAll('.chatbot_Overlay, [class*="chatbot_Overlay"], [class*="chatbot"], [id*="chatbot"]')
            .forEach(function(el) { el.remove(); });

        if (!window._overlayObserver) {
            window._overlayObserver = new MutationObserver(function(mutations) {
                mutations.forEach(function(m) {
                    m.addedNodes.forEach(function(node) {
                        if (node.nodeType === 1) {
                            var cls = (node.className || '').toString();
                            var id  = (node.id || '').toString();
                            if (cls.indexOf('chatbot') !== -1 || id.indexOf('chatbot') !== -1) {
                                node.remove();
                            }
                        }
                    });
                });
            });
            window._overlayObserver.observe(document.body, {childList: true, subtree: true});
        }
    """)
    time.sleep(0.3)


# ─────────────────────────────────────────────────────────────
#  SEARCH / JOB LINKS
# ─────────────────────────────────────────────────────────────
def do_search(driver, query):
    log(f"[*] Searching: '{query}'")
    keyword = query.lower().replace(" ", "-")
    driver.get(
        f"https://www.naukri.com/{keyword}-jobs?k={query.replace(' ','+')}"
        f"&l=Bengaluru&jobType=1&experienceMin=3&experienceMax=10"
    )
    time.sleep(5)
    log(f"    URL: {driver.current_url}")


def get_job_links(driver):
    time.sleep(2)
    seen, links = set(), []
    for a in driver.find_elements(By.TAG_NAME, "a"):
        href = a.get_attribute("href") or ""
        if "job-listings-" in href and href not in seen:
            seen.add(href)
            links.append(href)
    log(f"    {len(links)} jobs on page.")
    return links


# ─────────────────────────────────────────────────────────────
#  MODAL HANDLER
# ─────────────────────────────────────────────────────────────
def handle_apply_modal(driver):
    time.sleep(1.5)
    for _ in range(5):
        handled = False

        # Experience input
        exp_inputs = driver.find_elements(By.XPATH,
            "//*[contains(text(),'experience') or contains(text(),'Experience') or "
            "contains(text(),'years') or contains(text(),'Years')]"
            "/following::input[@type='text' or @type='number'][1]"
        )
        if not exp_inputs:
            exp_inputs = driver.find_elements(By.XPATH,
                "//input[@placeholder and (contains(@placeholder,'experience') or "
                "contains(@placeholder,'Experience') or contains(@placeholder,'year') or "
                "contains(@placeholder,'Year'))]"
            )
        for inp in exp_inputs:
            try:
                if inp.is_displayed():
                    inp.clear(); inp.send_keys("3"); handled = True
            except Exception:
                pass

        # CTC fields
        for ctc_kw, ctc_val in [("current ctc", "7"), ("current salary", "7"),
                                  ("expected ctc", "10"), ("expected salary", "10")]:
            for inp in driver.find_elements(By.XPATH,
                f"//input[@placeholder and contains(translate(@placeholder,"
                f"'ABCDEFGHIJKLMNOPQRSTUVWXYZ','abcdefghijklmnopqrstuvwxyz'),'{ctc_kw}')]"
            ):
                try:
                    if inp.is_displayed() and not inp.get_attribute("value"):
                        inp.clear(); inp.send_keys(ctc_val); handled = True
                except Exception:
                    pass

        # Location
        loc_inputs = driver.find_elements(By.XPATH,
            "//*[contains(text(),'location') or contains(text(),'Location') or "
            "contains(text(),'city') or contains(text(),'City') or "
            "contains(text(),'preferred')]"
            "/following::input[@type='text'][1]"
        )
        for inp in loc_inputs:
            try:
                if inp.is_displayed() and not inp.get_attribute("value"):
                    inp.send_keys("Bengaluru")
                    time.sleep(0.5)
                    suggs = driver.find_elements(By.XPATH,
                        "//ul[contains(@class,'suggest') or contains(@class,'dropdown')]//li[1]"
                    )
                    if suggs:
                        suggs[0].click()
                    handled = True
            except Exception:
                pass

        # Resume radio/checkbox
        for sel_xp in ["//input[@type='radio'][1]", "//input[@type='checkbox'][not(@checked)][1]"]:
            els = driver.find_elements(By.XPATH, sel_xp)
            if els:
                try:
                    driver.execute_script("arguments[0].click();", els[0]); handled = True
                except Exception:
                    pass
                break

        # Submit / Continue / Confirm buttons
        for xp in [
            "//button[normalize-space(text())='Submit']",
            "//button[normalize-space(text())='Continue']",
            "//button[normalize-space(text())='Save and continue']",
            "//button[normalize-space(text())='Confirm']",
            "//button[normalize-space(text())='Apply']",
            "//button[contains(@class,'btn-primary') and not(contains(text(),'Cancel'))]",
        ]:
            btns = driver.find_elements(By.XPATH, xp)
            for btn in btns:
                try:
                    if btn.is_displayed() and btn.is_enabled():
                        driver.execute_script("arguments[0].click();", btn)
                        time.sleep(1.5); handled = True; break
                except Exception:
                    pass

        # Close buttons
        for xp in [
            "//button[@aria-label='Close']", "//button[@aria-label='close']",
            "//span[@class='close' or @class='modal-close']",
            "//button[contains(@class,'close')]",
            "//*[contains(@class,'cross') or contains(@class,'dismiss')]",
        ]:
            for el in driver.find_elements(By.XPATH, xp):
                try:
                    if el.is_displayed():
                        el.click(); handled = True
                except Exception:
                    pass

        if not handled:
            break
        time.sleep(1)


# ─────────────────────────────────────────────────────────────
#  VERIFY APPLICATION SUBMITTED
# ─────────────────────────────────────────────────────────────
def _verify_applied(driver, timeout=12):
    """Return True only if the page shows real confirmation that the apply went through.

    Naukri's flow after a successful apply:
      - A modal appears (experience/resume/confirm), gets submitted by handle_apply_modal
      - After modal closes, the Apply button changes to a disabled/greyed state OR
        the page shows "Applied" / "Already Applied" text near the button area
      - A green toast/snackbar briefly appears at top/bottom

    We check for ALL of these — whichever appears first wins.
    """
    deadline = time.time() + timeout

    # These XPaths cover every known post-apply confirmation Naukri shows
    success_xpaths = [
        # Button area changes to "Applied" label
        "//*[contains(text(),'Already Applied')]",
        "//*[contains(text(),'already applied')]",
        "//*[contains(@class,'already-applied')]",
        "//*[@id='already-applied']",
        # Apply button becomes disabled after apply
        "//button[@disabled and (contains(text(),'Apply') or contains(text(),'Applied'))]",
        # Green toast/snackbar
        "//*[contains(@class,'toast') and (contains(text(),'applied') or contains(text(),'Applied') or contains(text(),'success') or contains(text(),'Success'))]",
        "//*[contains(@class,'snackbar') and contains(@class,'success')]",
        # Confirmation banners / modals
        "//*[contains(text(),'Application Submitted')]",
        "//*[contains(text(),'application submitted')]",
        "//*[contains(text(),'Successfully Applied')]",
        "//*[contains(text(),'successfully applied')]",
        "//*[contains(text(),'Thank you for applying')]",
        "//*[contains(@class,'applySuccess')]",
        "//*[contains(@class,'apply-success')]",
        "//*[contains(@class,'success-message')]",
        # Naukri-specific class seen in DOM after apply
        "//*[contains(@class,'applied-job')]",
        "//*[contains(@class,'job-applied')]",
    ]

    while time.time() < deadline:
        for xp in success_xpaths:
            try:
                els = driver.find_elements(By.XPATH, xp)
                if els and any(e.is_displayed() for e in els):
                    matched = els[0].text.strip()[:60]
                    log(f"    [verify] Confirmed: '{matched}'")
                    return True
            except Exception:
                pass
        time.sleep(0.5)

    # Timed out — screenshot for manual inspection
    screenshot(driver, "verify_failed")
    log("    [verify] Could not confirm application — marking as NOT applied.")
    return False


# ─────────────────────────────────────────────────────────────
#  TRY APPLY  (with self-healing)
# ─────────────────────────────────────────────────────────────
def try_apply(driver, _wait, _job_url):
    time.sleep(5)
    dismiss_overlay(driver)

    try:
        # ── Already applied check (DOM + JS page state) ───────────────────
        if driver.find_elements(By.ID, "already-applied"):
            log("    [-] Already applied."); return False
        if driver.find_elements(By.XPATH, "//*[contains(text(),'Already Applied')]"):
            log("    [-] Already applied."); return False
        # Check Naukri's window state for isApplied / alreadyApplied flags
        try:
            state_json = driver.execute_script(
                "try { return JSON.stringify(window.__INITIAL_STATE__ || {}); } catch(e) { return '{}'; }"
            )
            if state_json and ("alreadyApplied\":true" in state_json or "isApplied\":true" in state_json):
                log("    [-] Already applied (JS state)."); return False
        except Exception:
            pass

        # ── Find Apply button with heal_find ───────────────────────────────
        apply_btn = heal_find(driver, [
            "//*[@id='apply-button']",
            "//button[contains(@class,'apply-button')]",
            "//button[contains(@class,'applyBtn')]",
            "//button[normalize-space(text())='Apply']",
            "//button[normalize-space(text())='Easy Apply']",
            "//button[contains(text(),'Apply') and not(contains(text(),'Already')) and not(contains(text(),'Company'))]",
            "//a[normalize-space(text())='Apply']",
        ], label="Apply button", timeout=10)

        if not apply_btn:
            screenshot(driver, "no_apply_btn")
            log("    [!] No Apply button — skipping.")
            return False

        driver.execute_script("arguments[0].scrollIntoView({block:'center'});", apply_btn)
        time.sleep(0.5)
        dismiss_overlay(driver)
        time.sleep(0.3)

        # ── Intercept Naukri's apply XHR to catch duplicate-apply blocks ──
        driver.execute_script("""
            window._applyStatus = null;
            var _origOpen = XMLHttpRequest.prototype.open;
            var _origSend = XMLHttpRequest.prototype.send;
            XMLHttpRequest.prototype.open = function(method, url) {
                this._url = url;
                return _origOpen.apply(this, arguments);
            };
            XMLHttpRequest.prototype.send = function() {
                var self = this;
                this.addEventListener('load', function() {
                    if (self._url && self._url.indexOf('/apiv2/') !== -1 &&
                        self._url.indexOf('apply') !== -1) {
                        window._applyStatus = self.status;
                        window._applyUrl    = self._url;
                    }
                });
                return _origSend.apply(this, arguments);
            };
        """)

        # ── Click Apply and verify ─────────────────────────────────────────
        # Naukri navigates to a confirmation page: "Applied to <JobTitle>"
        # on success. On duplicate apply it silently does nothing.
        for attempt in range(1, 4):
            clicked = heal_click(driver, apply_btn, label=f"Apply(attempt {attempt})")
            if not clicked:
                break

            # Wait up to 6s for confirmation text or API signal
            deadline = time.time() + 6
            while time.time() < deadline:
                # Primary: confirmation text on the page
                conf_els = driver.find_elements(By.XPATH,
                    "//*[starts-with(normalize-space(text()),'Applied to') or "
                    "contains(text(),'Already Applied') or "
                    "contains(text(),'Application Submitted') or "
                    "contains(text(),'Successfully Applied')]"
                )
                if any(c.is_displayed() for c in conf_els):
                    msg = conf_els[0].text.strip()[:80]
                    log(f"    [verify] Confirmed: '{msg}'")
                    return True

                # Secondary: XHR apply API returned conflict / already-applied
                api_status = driver.execute_script("return window._applyStatus;")
                if api_status is not None:
                    if api_status in (200, 201):
                        log(f"    [verify] Apply API {api_status} — success.")
                        return True
                    elif api_status in (409, 400, 403):
                        log(f"    [verify] Apply API {api_status} — already applied / blocked.")
                        return False

                time.sleep(0.4)

            if attempt < 3:
                log(f"    [heal] No confirmation after attempt {attempt} — re-clicking")
                apply_btn = heal_find(driver, [
                    "//*[@id='apply-button']",
                    "//button[contains(@class,'apply-button')]",
                    "//button[normalize-space(text())='Apply']",
                    "//button[normalize-space(text())='Easy Apply']",
                    "//button[contains(text(),'Apply') and not(contains(text(),'Already')) "
                    "and not(contains(text(),'Company'))]",
                ], label="Apply button re-fetch", timeout=5)
                if not apply_btn:
                    break
                dismiss_overlay(driver)
                driver.execute_script("window._applyStatus = null;")
                time.sleep(0.3)

        screenshot(driver, "no_confirmation_after_click")
        log("    [!] No confirmation after clicking Apply — skipping.")
        return False

    except (TimeoutException, ElementClickInterceptedException, NoSuchElementException) as e:
        log(f"    [!] Apply error: {type(e).__name__}: {str(e)[:120]}")
        screenshot(driver, "apply_exception")
        return False


# ─────────────────────────────────────────────────────────────
#  QUERY LOOP
# ─────────────────────────────────────────────────────────────
def apply_for_query(driver, wait, query):
    do_search(driver, query)
    base_url = driver.current_url
    applied  = 0
    page     = 1

    while applied < MAX_APPLIES_PER_QUERY:
        if page > 1:
            sep = "&" if "?" in base_url else "?"
            driver.get(base_url + f"{sep}pageNo={page}")
            time.sleep(4)

        print(f"\n  [page {page}] {driver.current_url}")
        job_links = get_job_links(driver)

        if not job_links:
            log("  No more jobs."); break

        main_win = driver.current_window_handle

        for url in job_links:
            if applied >= MAX_APPLIES_PER_QUERY:
                break
            try:
                driver.execute_script("window.open('');")
                driver.switch_to.window(driver.window_handles[-1])
                driver.get(url)

                if try_apply(driver, wait, url):
                    applied += 1
                    log(f"  [+] Applied ({applied}/{MAX_APPLIES_PER_QUERY}): {url}")
                else:
                    log(f"  [-] Skipped: {url}")

            except Exception as e:
                log(f"  [!] Error: {e}")
                screenshot(driver, "loop_error")
            finally:
                try:
                    driver.close()
                    driver.switch_to.window(main_win)
                except Exception:
                    pass
                time.sleep(1)

        page += 1

    log(f"  [=] '{query}': applied {applied}")
    return applied


# ─────────────────────────────────────────────────────────────
#  MAIN
# ─────────────────────────────────────────────────────────────
def main():
    if not EMAIL or not PASSWORD:
        log("[!] Set NAUKRI_EMAIL and NAUKRI_PASSWORD in .env")
        return

    log("=" * 60)
    log("[START] Naukri Auto-Apply")
    driver = init_driver()
    wait   = WebDriverWait(driver, 12)
    total  = 0

    try:
        login(driver, wait)
        for query in SEARCH_QUERIES:
            total += apply_for_query(driver, wait, query)
        log(f"[DONE] Total applied: {total}")
    except Exception as e:
        log(f"[!] Fatal: {e}")
        traceback.print_exc()
        screenshot(driver, "fatal_error")
    finally:
        time.sleep(3)
        driver.quit()


# ─────────────────────────────────────────────────────────────
#  SCHEDULER
# ─────────────────────────────────────────────────────────────
def schedule_daily(run_time="09:00"):
    script  = os.path.abspath(__file__)
    python  = sys.executable
    bat     = os.path.join(os.path.dirname(script), "run_naukri.bat")
    task    = "NaukriAutoApply"
    _hour, _minute = run_time.split(":")

    with open(bat, "w") as f:
        f.write(f'@echo off\n"{python}" -u "{script}"\n')

    cmd = [
        "schtasks", "/create", "/f",
        "/tn", task, "/tr", bat,
        "/sc", "DAILY", "/st", run_time, "/rl", "HIGHEST",
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode == 0:
        print(f"[OK] Task '{task}' scheduled daily at {run_time}")
        print(f"     Launcher : {bat}")
        print(f"     Log file : {LOG_FILE}")
        print(f"     To remove: schtasks /delete /tn {task} /f")
    else:
        print(f"[!] Scheduling failed: {result.stderr.strip()}")
        print("    Try running this script as Administrator.")


if __name__ == "__main__":
    if len(sys.argv) > 1 and sys.argv[1] == "--schedule":
        run_time = sys.argv[2] if len(sys.argv) > 2 else "09:00"
        schedule_daily(run_time)
    else:
        main()

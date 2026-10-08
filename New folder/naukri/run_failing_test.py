"""
run_failing_test.py
====================
Simulates common failure scenarios on a real Naukri job page and verifies
that the self-healing helpers in naukri_auto_apply.py recover correctly.

Run:
    python run_failing_test.py

All results are printed + saved to naukri_heal_test.log
"""

import time
import os
import sys
sys.stdout.reconfigure(encoding='utf-8', errors='replace')
from datetime import datetime
from dotenv import load_dotenv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import (
    ElementClickInterceptedException, NoSuchElementException, TimeoutException,
)

# Import self-healing helpers from the main script
sys.path.insert(0, os.path.dirname(__file__))
from naukri_auto_apply import (
    heal_click, heal_find, dismiss_overlay, try_apply,
    login, init_driver, screenshot, log as nlog,
)

load_dotenv()

EMAIL    = os.getenv("NAUKRI_EMAIL")
PASSWORD = os.getenv("NAUKRI_PASSWORD")

LOG_FILE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "naukri_heal_test.log")


def tlog(msg):
    ts   = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    line = f"[{ts}] {msg}"
    print(line)
    with open(LOG_FILE, "a", encoding="utf-8") as f:
        f.write(line + "\n")


# ─── test result tracker ────────────────────────────────────
RESULTS = []

def record(name, passed, detail=""):
    status = "PASS" if passed else "FAIL"
    RESULTS.append((name, status, detail))
    tlog(f"  [{status}] {name}" + (f" - {detail}" if detail else ""))


# ─── individual tests ────────────────────────────────────────

def test_overlay_dismissed(driver):
    """Verify that dismiss_overlay removes/hides the chatbot overlay."""
    tlog("\n[TEST] overlay_dismissed")
    driver.get("https://www.naukri.com/")
    time.sleep(4)

    # Inject a fake overlay to simulate what Naukri does
    driver.execute_script("""
        var d = document.createElement('div');
        d.className = 'chatbot_Overlay chatbot_fake_test';
        d.id = 'chatbot_fake';
        d.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;background:rgba(0,0,0,0.5);z-index:9999;';
        document.body.appendChild(d);
    """)
    time.sleep(0.5)

    visible_before = driver.execute_script(
        "var el=document.getElementById('chatbot_fake'); return el && el.offsetParent!==null;"
    )

    dismiss_overlay(driver)
    time.sleep(0.5)

    still_present = driver.execute_script(
        "return !!document.getElementById('chatbot_fake');"
    )
    record("overlay_dismissed", not still_present,
           f"visible_before={visible_before}, still_present={still_present}")


def test_heal_find_primary(driver):
    """heal_find returns element via first matching XPath."""
    tlog("\n[TEST] heal_find_primary")
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)

    el = heal_find(driver, [
        "//input[@id='usernameField']",
        "//input[@type='email']",
    ], label="login_email", timeout=8)

    record("heal_find_primary", el is not None,
           f"found={el is not None}")


def test_heal_find_fallback(driver):
    """heal_find falls back to second XPath when the first doesn't exist."""
    tlog("\n[TEST] heal_find_fallback")
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)

    el = heal_find(driver, [
        "//input[@id='this_id_does_not_exist_xyz']",      # wrong → miss
        "//input[@id='passwordField']",                    # correct → hit
    ], label="password_fallback", timeout=8)

    record("heal_find_fallback", el is not None,
           f"found={el is not None}, id={el.get_attribute('id') if el else 'N/A'}")


def test_heal_find_timeout(driver):
    """heal_find returns None when no XPath matches within timeout."""
    tlog("\n[TEST] heal_find_timeout")
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)

    start = time.time()
    el    = heal_find(driver, ["//button[@id='does_not_exist_ever']"],
                     label="nonexistent", timeout=3)
    elapsed = round(time.time() - start, 1)

    record("heal_find_timeout", el is None and elapsed >= 2.5,
           f"el={el}, elapsed={elapsed}s")


def test_heal_click_normal(driver, wait):
    """heal_click succeeds on a visible, clickable button on the homepage."""
    tlog("\n[TEST] heal_click_normal")
    driver.get("https://www.naukri.com/")
    time.sleep(4)

    btn = heal_find(driver, [
        "//button[contains(@class,'nI-gNb')]",
        "//button[contains(@class,'search')]",
        "(//button)[1]",
    ], label="homepage_btn", timeout=8)

    if btn is None:
        record("heal_click_normal", False, "no button found on homepage")
        return

    result = heal_click(driver, btn, label="homepage_btn")
    record("heal_click_normal", result, f"clicked={result}")
    time.sleep(2)


def test_heal_click_intercepted(driver):
    """heal_click falls back to JS when a fake overlay intercepts regular click."""
    tlog("\n[TEST] heal_click_intercepted")
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)

    # Inject a transparent overlay that blocks normal clicks
    driver.execute_script("""
        var o = document.createElement('div');
        o.id = 'fake_intercept_overlay';
        o.style.cssText = 'position:fixed;top:0;left:0;width:100%;height:100%;z-index:99999;background:transparent;';
        document.body.appendChild(o);
    """)
    time.sleep(0.3)

    btn    = driver.find_element(By.XPATH, "//button[@type='submit']")
    result = heal_click(driver, btn, label="intercepted_btn")

    # Remove overlay after test
    driver.execute_script("var o=document.getElementById('fake_intercept_overlay');if(o)o.remove();")

    record("heal_click_intercepted", result,
           f"healed={result} (strategies 2+ used)")


def test_try_apply_real_job(driver, wait):
    """Open a real job page and let try_apply run — checks it doesn't crash."""
    tlog("\n[TEST] try_apply_real_job")

    # Search for SDET and pick the first job link
    driver.get("https://www.naukri.com/sdet-jobs-in-bengaluru")
    time.sleep(5)

    links = []
    for a in driver.find_elements(By.TAG_NAME, "a"):
        href = a.get_attribute("href") or ""
        if "job-listings-" in href and href not in links:
            links.append(href)

    if not links:
        record("try_apply_real_job", False, "no job links found on search page")
        return

    job_url = links[0]
    tlog(f"    Testing on: {job_url}")

    main_win = driver.current_window_handle
    driver.execute_script("window.open('');")
    driver.switch_to.window(driver.window_handles[-1])
    driver.get(job_url)

    try:
        result = try_apply(driver, wait, job_url)
        record("try_apply_real_job", True,
               f"try_apply returned {result} (True=applied, False=skipped - both OK)")
    except Exception as e:
        record("try_apply_real_job", False, f"exception: {e}")
        screenshot(driver, "try_apply_real_exception")
    finally:
        driver.close()
        driver.switch_to.window(main_win)


# ─── main runner ────────────────────────────────────────────
def main():
    if not EMAIL or not PASSWORD:
        tlog("[!] Set NAUKRI_EMAIL and NAUKRI_PASSWORD in .env"); return

    tlog("=" * 60)
    tlog("[START] Self-Heal Test Suite")

    driver = init_driver()
    wait   = WebDriverWait(driver, 12)

    try:
        # Tests that don't need login
        test_overlay_dismissed(driver)
        test_heal_find_primary(driver)
        test_heal_find_fallback(driver)
        test_heal_find_timeout(driver)
        test_heal_click_intercepted(driver)

        # Tests that need login
        tlog("\n[*] Logging in for remaining tests...")
        login(driver, wait)

        test_heal_click_normal(driver, wait)
        test_try_apply_real_job(driver, wait)

    except Exception as e:
        tlog(f"[!] Suite error: {e}")
        screenshot(driver, "suite_error")
    finally:
        driver.quit()

    # ── Summary ──────────────────────────────────────────────
    tlog("\n" + "=" * 60)
    tlog("RESULTS SUMMARY")
    tlog("=" * 60)
    passed = sum(1 for _, s, _ in RESULTS if s == "PASS")
    failed = sum(1 for _, s, _ in RESULTS if s == "FAIL")
    for name, status, detail in RESULTS:
        mark = "[+]" if status == "PASS" else "[-]"
        tlog(f"  {mark} [{status}] {name}" + (f" - {detail}" if detail else ""))
    tlog(f"\n  {passed} passed, {failed} failed out of {len(RESULTS)} tests")
    tlog(f"  Log: {LOG_FILE}")

    if failed:
        sys.exit(1)


if __name__ == "__main__":
    main()

"""
LinkedIn Job Application Automation Agent
Candidate : Yashwanth MH  |  Experience : 3 Years (SDET / QA)
"""

import re
import csv
import time
import os
from datetime import datetime

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import (
    TimeoutException,
    NoSuchElementException,
    ElementClickInterceptedException,
)

# ──────────────────────────────────────────────────────
# CONFIG  ← adjust before running
# ──────────────────────────────────────────────────────
# Dedicated automation profile — won't conflict with your regular Chrome
USER_DATA_DIR = os.path.join(os.path.expanduser("~"), "chrome_linkedin_automation")
PROFILE_DIR   = "Default"

CANDIDATE_EXP_YEARS = 3
PREFERRED_LOCATION  = "Remote"          # e.g. "Bangalore", "United States", "Remote"

SEARCH_QUERIES = [
    "SDET",
    "QA Engineer",
    "Software Development Engineer in Test",
    "Automation Test Engineer",
    "QA Automation Engineer",
]

LOG_FILE = os.path.join(os.path.dirname(__file__), "linkedin_applications.csv")
WAIT_SEC = 10   # default explicit-wait timeout

# ──────────────────────────────────────────────────────
# APPLICATION LOG
# ──────────────────────────────────────────────────────
applied_jobs:    list[dict] = []
skipped_jobs:    list[dict] = []
borderline_jobs: list[dict] = []


def log_application(company, title, location, url, exp_required, status, notes=""):
    entry = {
        "#":            len(applied_jobs) + len(skipped_jobs) + 1,
        "Company":      company,
        "Title":        title,
        "Location":     location,
        "URL":          url,
        "Exp Required": exp_required,
        "Date Applied": datetime.now().strftime("%Y-%m-%d %H:%M") if status == "Applied" else "",
        "Status":       status,
        "Notes":        notes,
    }
    if status == "Applied":
        applied_jobs.append(entry)
    else:
        skipped_jobs.append(entry)


def save_log():
    all_entries = applied_jobs + skipped_jobs
    if not all_entries:
        return
    with open(LOG_FILE, "w", newline="", encoding="utf-8") as f:
        writer = csv.DictWriter(f, fieldnames=all_entries[0].keys())
        writer.writeheader()
        writer.writerows(all_entries)
    print(f"\n  📋 Log saved → {LOG_FILE}")


def print_summary():
    print("\n" + "=" * 58)
    print("  END OF SESSION SUMMARY")
    print("=" * 58)
    print(f"  ✅ Jobs Applied       : {len(applied_jobs)}")
    print(f"  ⏭  Jobs Skipped       : {len(skipped_jobs)}")
    print(f"  ⚠️  Borderline Flagged : {len(borderline_jobs)}")
    if applied_jobs:
        print(f"\n  {'#':<3} {'Company':<25} {'Title':<30} {'Status'}")
        print(f"  {'-'*3} {'-'*25} {'-'*30} {'-'*10}")
        for j in applied_jobs:
            print(f"  {j['#']:<3} {j['Company']:<25} {j['Title'][:30]:<30} {j['Status']}")
    save_log()


# ──────────────────────────────────────────────────────
# BROWSER SETUP
# ──────────────────────────────────────────────────────
def create_driver() -> webdriver.Chrome:
    opts = Options()
    opts.add_argument(f"--user-data-dir={USER_DATA_DIR}")
    opts.add_argument(f"--profile-directory={PROFILE_DIR}")
    opts.add_argument("--start-maximized")
    opts.add_argument("--disable-blink-features=AutomationControlled")
    opts.add_experimental_option("excludeSwitches", ["enable-automation"])
    opts.add_experimental_option("useAutomationExtension", False)
    return webdriver.Chrome(options=opts)  # Selenium Manager auto-downloads chromedriver


# ──────────────────────────────────────────────────────
# STEP 2 — LOGIN CHECK
# ──────────────────────────────────────────────────────
def ensure_logged_in(driver: webdriver.Chrome):
    driver.get("https://www.linkedin.com")
    time.sleep(3)
    if "feed" in driver.current_url or _present(driver, By.CSS_SELECTOR, ".global-nav__me-photo"):
        print("✅ Already logged in.")
        return
    print("⚠️  Not logged in.")
    print("   Complete login (CAPTCHA / 2FA) in the browser, then press ENTER here.")
    input("   > Press ENTER after login is complete … ")
    time.sleep(2)
    if "feed" not in driver.current_url:
        input("   ⚠️  Login not confirmed — press ENTER once you see your LinkedIn feed … ")


# ──────────────────────────────────────────────────────
# HELPERS
# ──────────────────────────────────────────────────────
def _present(driver, by, value) -> bool:
    try:
        driver.find_element(by, value)
        return True
    except NoSuchElementException:
        return False


def _click(driver, el):
    try:
        el.click()
    except ElementClickInterceptedException:
        driver.execute_script("arguments[0].click();", el)


def _wait(driver, by, value, timeout=WAIT_SEC):
    return WebDriverWait(driver, timeout).until(EC.presence_of_element_located((by, value)))


def _wait_click(driver, by, value, timeout=WAIT_SEC):
    return WebDriverWait(driver, timeout).until(EC.element_to_be_clickable((by, value)))


# ──────────────────────────────────────────────────────
# STEP 3 — SEARCH WITH FILTERS (URL-encoded)
# ──────────────────────────────────────────────────────
def search_jobs(driver: webdriver.Chrome, query: str):
    print(f"\n🔍  Searching: '{query}'  |  Location: '{PREFERRED_LOCATION}'")
    url = (
        "https://www.linkedin.com/jobs/search/"
        f"?keywords={query.replace(' ', '%20')}"
        f"&location={PREFERRED_LOCATION.replace(' ', '%20')}"
        "&f_AL=true"          # Easy Apply only
        "&f_TPR=r86400"       # Past 24 hours
        "&f_E=2%2C3"          # Associate(2) + Mid-Senior(3)
        "&f_JT=F"             # Full-time
        "&sortBy=DD"          # Sort by date
    )
    driver.get(url)
    time.sleep(3)


# ──────────────────────────────────────────────────────
# STEP 4 — SCREENING LOGIC
# ──────────────────────────────────────────────────────
MATCH_SKILLS = [
    "selenium", "cypress", "playwright", "appium",
    "java", "python", "javascript",
    "rest api", "postman", "rest assured",
    "jenkins", "github actions", "gitlab ci",
    "agile", "scrum",
    "test plan", "test case", "bug tracking",
    "jira", "testrail", "zephyr",
    "manual testing", "automation testing",
    "mobile testing", "ios", "android",
    "jmeter", "gatling", "performance testing",
]

SKIP_PHRASES = [
    "5+ years", "6+ years", "7+ years", "8+ years", "10+ years",
    "minimum 5 years", "at least 5 years",
    "entry level, 0", "0-1 year", "0 to 1 year",
]

BORDERLINE_PHRASES = [
    "5 years preferred", "5+ preferred",
    "5+ years preferred (not required)",
]


def _extract_exp(text: str):
    """Return (min_years, max_years) from description text, or (None, None)."""
    for pattern in [
        r"(\d+)\s*(?:to|-)\s*(\d+)\s*years?",
        r"(\d+)\+\s*years?",
        r"(\d+)\s*years?\s*(?:of\s*)?experience",
    ]:
        m = re.search(pattern, text, re.IGNORECASE)
        if m:
            nums = [int(g) for g in m.groups() if g is not None]
            return min(nums), max(nums)
    return None, None


def screen_job(title: str, description: str) -> tuple[str, list[str], str]:
    """Returns (decision, matched_skills, notes).
    decision ∈ {'INCLUDE', 'SKIP', 'BORDERLINE'}
    """
    dl = description.lower()
    tl = title.lower()

    for phrase in SKIP_PHRASES:
        if phrase in dl:
            return "SKIP", [], f"Contains skip phrase: '{phrase}'"

    for phrase in BORDERLINE_PHRASES:
        if phrase in dl:
            return "BORDERLINE", [], f"Borderline phrase: '{phrase}'"

    matched = [s for s in MATCH_SKILLS if s in dl]

    min_exp, max_exp = _extract_exp(dl)

    if min_exp is not None:
        if min_exp >= 5:
            return "SKIP", matched, f"Requires {min_exp}+ years (too senior)"
        if min_exp <= 1 and (max_exp is None or max_exp <= 1):
            return "SKIP", matched, "Too junior (0–1 year range)"

    senior_title = any(w in tl for w in ["senior", "lead", "principal", "staff"])
    if senior_title:
        if min_exp and min_exp >= 5:
            return "SKIP", matched, f"Senior/Lead title + {min_exp}+ yrs required"
        if min_exp and min_exp in (3, 4):
            return "BORDERLINE", matched, f"Senior title but only {min_exp} yrs required"

    return "INCLUDE", matched, "Passes screening criteria"


# ──────────────────────────────────────────────────────
# STEP 5 — HUMAN APPROVAL PROMPT
# ──────────────────────────────────────────────────────
def ask_human_approval(job: dict) -> str:
    """Print job card, return 'YES' | 'SKIP' | 'STOP'."""
    icon = {"INCLUDE": "✅", "BORDERLINE": "⚠️", "SKIP": "❌"}.get(job.get("exp_fit", ""), "")
    skills_str = ", ".join(job.get("matched_skills", []))[:38]

    W = 54
    def row(label, value):
        value = str(value)
        print(f"│  {label:<14}: {value[:W-18]:<{W-18}}│")

    print("\n┌" + "─" * W + "┐")
    print(f"│{'  🔍 JOB FOUND — AWAITING YOUR APPROVAL':<{W}}│")
    print("│" + "─" * W + "│")
    row("Company",      job["company"])
    row("Job Title",    job["title"])
    row("Location",     job["location"])
    row("Posted",       job["posted"])
    row("URL",          job["url"])
    row("Apply Type",   "Easy Apply")
    print("│" + "─" * W + "│")
    row("Exp Required", job.get("exp_required", "Not stated"))
    row("Candidate Exp", f"3 Years  {icon}")
    row("Match Skills", skills_str or "—")
    row("Notes",        job.get("notes", ""))
    print("│" + "─" * W + "│")
    print(f"│  → Approve?   [YES] / [SKIP] / [STOP]{' ' * (W-39)}│")
    print("└" + "─" * W + "┘")

    while True:
        choice = input("  Your choice: ").strip().upper()
        if choice in ("YES", "SKIP", "STOP"):
            return choice
        print("  Please type YES, SKIP, or STOP.")


# ──────────────────────────────────────────────────────
# STEP 6 — EASY APPLY MODAL WALKER
# ──────────────────────────────────────────────────────
def fill_easy_apply(driver: webdriver.Chrome, job: dict) -> bool:
    """Walk every Easy Apply step. Returns True if submitted."""
    try:
        btn = _wait_click(driver, By.CSS_SELECTOR,
                          ".jobs-apply-button--top-card button", timeout=6)
        _click(driver, btn)
        time.sleep(2)
    except TimeoutException:
        print("  ❌ Easy Apply button not found on this listing.")
        return False

    for step in range(1, 20):
        time.sleep(1.5)

        if not driver.find_elements(By.CSS_SELECTOR, ".jobs-easy-apply-modal"):
            print("  ❌ Modal closed unexpectedly.")
            return False

        # Fill numeric experience fields
        for inp in driver.find_elements(By.CSS_SELECTOR, "input[type='number']"):
            try:
                inp.clear()
                inp.send_keys("3")
            except Exception:
                pass

        # Fill text experience inputs labelled with "years"
        for label_el in driver.find_elements(By.XPATH,
                "//label[contains(translate(text(),'ABCDEFGHIJKLMNOPQRSTUVWXYZ',"
                "'abcdefghijklmnopqrstuvwxyz'),'years')]"):
            try:
                inp_id = label_el.get_attribute("for")
                inp = driver.find_element(By.ID, inp_id)
                if inp.get_attribute("type") in ("text", "number"):
                    inp.clear()
                    inp.send_keys("3")
            except Exception:
                pass

        # Handle free-text / textarea questions
        for ta in driver.find_elements(By.CSS_SELECTOR,
                                       ".jobs-easy-apply-form-section__grouping textarea"):
            if ta.get_attribute("value", ).strip():
                continue                         # already filled
            try:
                lbl = ta.find_element(
                    By.XPATH, "./ancestor::div[contains(@class,'form-component')]//label")
                question = lbl.text.strip()
            except Exception:
                question = "Additional information"
            print(f"\n  📝 Question: \"{question}\"")
            print("  Type your answer (blank line to finish):")
            lines = []
            while True:
                line = input("  > ")
                if line == "" and lines:
                    break
                lines.append(line)
            answer = "\n".join(lines)
            if answer.strip():
                ta.clear()
                ta.send_keys(answer)

        # Submit button visible → final confirmation
        submit_btns = driver.find_elements(
            By.CSS_SELECTOR, "button[aria-label='Submit application']")
        if submit_btns:
            confirm = input(
                f"\n  ⚠️  Ready to SUBMIT to {job['company']}. "
                "Type CONFIRM to submit, anything else to cancel: "
            ).strip().upper()
            if confirm == "CONFIRM":
                _click(driver, submit_btns[0])
                time.sleep(2)
                print(f"  ✅ Application submitted to {job['company']}!")
                for close_btn in driver.find_elements(By.CSS_SELECTOR, "button[aria-label='Dismiss']"):
                    _click(driver, close_btn)
                    break
                return True
            else:
                print("  ⏭  Cancelled by user.")
                for close_btn in driver.find_elements(By.CSS_SELECTOR, "button[aria-label='Dismiss']"):
                    _click(driver, close_btn)
                    break
                return False

        # Review → Next → Continue
        for selector in [
            "button[aria-label='Review your application']",
            "button[aria-label='Continue to next step']",
        ]:
            btns = driver.find_elements(By.CSS_SELECTOR, selector)
            if btns:
                _click(driver, btns[0])
                break
        else:
            primary = driver.find_elements(By.CSS_SELECTOR, ".artdeco-button--primary")
            if primary:
                _click(driver, primary[-1])
            else:
                print("  ⚠️  Cannot find Next/Submit. Complete manually then press ENTER.")
                input("  > ")

    print("  ⚠️  Too many steps — aborting this application.")
    return False


# ──────────────────────────────────────────────────────
# COLLECT JOB CARDS FROM SEARCH RESULTS PAGE
# ──────────────────────────────────────────────────────
def collect_job_cards(driver: webdriver.Chrome) -> list[dict]:
    jobs: list[dict] = []
    seen: set[str] = set()

    for _ in range(6):                          # scroll up to 6 pages of results
        cards = driver.find_elements(By.CSS_SELECTOR, ".jobs-search-results__list-item")
        for card in cards:
            try:
                link = card.find_element(By.CSS_SELECTOR, "a.job-card-list__title")
                url  = link.get_attribute("href").split("?")[0]
                if url in seen:
                    continue
                seen.add(url)

                title = link.text.strip()
                try:
                    company = card.find_element(
                        By.CSS_SELECTOR, ".job-card-container__primary-description").text.strip()
                except Exception:
                    company = "Unknown"
                try:
                    location = card.find_element(
                        By.CSS_SELECTOR, ".job-card-container__metadata-item").text.strip()
                except Exception:
                    location = "Unknown"
                try:
                    posted = card.find_element(By.CSS_SELECTOR, "time").text.strip()
                except Exception:
                    posted = "Unknown"

                jobs.append({"url": url, "title": title,
                              "company": company, "location": location, "posted": posted})
            except Exception:
                continue

        driver.execute_script("window.scrollBy(0, 800);")
        time.sleep(1.5)

    return jobs


def get_job_description(driver: webdriver.Chrome, url: str) -> str:
    driver.get(url)
    time.sleep(2)
    try:
        el = _wait(driver, By.CSS_SELECTOR, ".jobs-description__content", timeout=8)
        return el.text
    except TimeoutException:
        return ""


# ──────────────────────────────────────────────────────
# MAIN
# ──────────────────────────────────────────────────────
def run():
    driver = create_driver()
    applied_urls: set[str] = set()

    try:
        ensure_logged_in(driver)               # STEP 1 & 2

        for query in SEARCH_QUERIES:
            search_jobs(driver, query)         # STEP 3
            time.sleep(2)

            cards = collect_job_cards(driver)
            print(f"  Found {len(cards)} listing(s) for '{query}'")

            for job in cards:
                if job["url"] in applied_urls:
                    continue

                description = get_job_description(driver, job["url"])

                # STEP 4 — screen
                decision, matched_skills, notes = screen_job(job["title"], description)

                exp_m = re.search(r"(\d+\+?\s*(?:to|-)?\s*\d*\s*years?[^.\n]*)",
                                  description, re.IGNORECASE)
                exp_required_str = exp_m.group(0).strip() if exp_m else "Not stated"

                job["matched_skills"] = matched_skills[:6]
                job["exp_fit"]        = decision
                job["exp_required"]   = exp_required_str
                job["notes"]          = notes

                if decision == "SKIP":
                    print(f"  ⏭  SKIP  {job['title']} @ {job['company']} — {notes}")
                    log_application(job["company"], job["title"], job["location"],
                                    job["url"], exp_required_str, "Skipped (auto)", notes)
                    continue

                if decision == "BORDERLINE":
                    borderline_jobs.append(job)

                # STEP 5 — human approval
                choice = ask_human_approval(job)

                if choice == "STOP":
                    print("\n🛑 Session stopped by user.")
                    return

                if choice == "SKIP":
                    log_application(job["company"], job["title"], job["location"],
                                    job["url"], exp_required_str, "Skipped (human)", notes)
                    continue

                # STEP 6 — apply
                driver.get(job["url"])
                time.sleep(2)
                submitted = fill_easy_apply(driver, job)
                status = "Applied" if submitted else "Apply Failed"
                log_application(job["company"], job["title"], job["location"],
                                job["url"], exp_required_str, status, notes)
                if submitted:
                    applied_urls.add(job["url"])

    except KeyboardInterrupt:
        print("\n\n🛑 Interrupted by user (Ctrl+C).")
    finally:
        print_summary()                        # STEP 8
        input("\nPress ENTER to close the browser … ")
        driver.quit()


if __name__ == "__main__":
    run()

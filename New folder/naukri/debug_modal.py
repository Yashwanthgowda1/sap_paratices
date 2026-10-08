"""One-off: click Apply on a fresh job and dump what appears in the DOM."""
import time, os
from dotenv import load_dotenv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

load_dotenv()
EMAIL    = os.getenv("NAUKRI_EMAIL")
PASSWORD = os.getenv("NAUKRI_PASSWORD")
SS_DIR   = os.path.join(os.path.dirname(os.path.abspath(__file__)), "screenshots")
os.makedirs(SS_DIR, exist_ok=True)

options = webdriver.ChromeOptions()
options.add_argument("--start-maximized")
options.add_argument("--disable-notifications")
options.add_experimental_option("excludeSwitches", ["enable-automation"])
driver = webdriver.Chrome(options=options)
wait   = WebDriverWait(driver, 15)

try:
    # Login
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)
    wait.until(EC.presence_of_element_located((By.ID, "usernameField"))).send_keys(EMAIL)
    driver.find_element(By.ID, "passwordField").send_keys(PASSWORD)
    driver.find_element(By.XPATH, "//button[@type='submit']").click()
    time.sleep(4)
    print("[+] Logged in")

    # Search for a different keyword to find fresh (unapplied) jobs
    driver.get("https://www.naukri.com/manual-testing-jobs?k=Manual+Testing&l=Bengaluru&jobType=1")
    time.sleep(5)
    links = []
    for a in driver.find_elements(By.TAG_NAME, "a"):
        href = a.get_attribute("href") or ""
        if "job-listings-" in href and href not in links:
            links.append(href)
    print(f"[+] Found {len(links)} job links")

    # Open each in new tab until we find one with a clickable Apply button
    main_win = driver.current_window_handle
    btn = None
    TEST_JOB = None
    for url in links[:20]:
        driver.execute_script("window.open('');")
        driver.switch_to.window(driver.window_handles[-1])
        driver.get(url)
        time.sleep(4)
        for xp in ["//*[@id='apply-button']",
                   "//button[normalize-space(text())='Apply']",
                   "//button[contains(text(),'Apply') and not(contains(text(),'Already')) and not(contains(text(),'Company'))]"]:
            els = driver.find_elements(By.XPATH, xp)
            if els and els[0].is_displayed():
                btn = els[0]
                TEST_JOB = url
                print(f"[+] Fresh job: {url}")
                print(f"    btn class={btn.get_attribute('class')!r} id={btn.get_attribute('id')!r}")
                break
        if btn:
            break
        driver.close()
        driver.switch_to.window(main_win)

    if not btn:
        print("[!] No fresh unapplied job found"); driver.quit(); exit(1)

    driver.save_screenshot(f"{SS_DIR}/dm_01_before_click.png")

    # Kill chatbot overlay
    driver.execute_script("""
        document.querySelectorAll('[class*="chatbot"],[id*="chatbot"]').forEach(e=>e.remove());
    """)
    time.sleep(0.3)

    # Scroll and click
    driver.execute_script("arguments[0].scrollIntoView({block:'center'});", btn)
    time.sleep(0.5)
    driver.execute_script("arguments[0].click();", btn)
    print("[+] Clicked Apply")
    time.sleep(0.5)
    driver.save_screenshot(f"{SS_DIR}/dm_02_right_after_click.png")

    # Poll DOM for 8 seconds and dump every visible element
    print("\n--- Polling DOM for 8 seconds ---")
    for i in range(16):
        time.sleep(0.5)
        els = driver.find_elements(By.XPATH, "//*[@role='dialog' or @role='alertdialog']") + \
              driver.find_elements(By.XPATH,
                  "//*[contains(@class,'modal') or contains(@class,'popup') or "
                  "contains(@class,'applyModal') or contains(@class,'apply') or "
                  "contains(@class,'overlay') or contains(@class,'dialog') or "
                  "contains(@class,'drawer') or contains(@class,'sheet')]"
                  "[not(contains(@class,'chatbot'))]"
              )
        visible = [(e.tag_name, (e.get_attribute('class') or '')[:80], e.get_attribute('id') or '')
                   for e in els if e.is_displayed()]
        if visible:
            print(f"  [{i*0.5:.1f}s] {len(visible)} visible modal-ish elements:")
            for tag, cls, eid in visible[:15]:
                print(f"    <{tag} class={cls!r} id={eid!r}>")
            driver.save_screenshot(f"{SS_DIR}/dm_03_modal_visible.png")
            break
        else:
            print(f"  [{i*0.5:.1f}s] nothing yet...")

    driver.save_screenshot(f"{SS_DIR}/dm_04_after_poll.png")

    # Dump page source keywords
    src = driver.page_source
    for kw in ['applyModal', 'apply-modal', 'applyForm', 'role="dialog"', 'chatbot', 'Already Applied']:
        idx = src.find(kw)
        if idx != -1:
            print(f"\n[SRC] '{kw}' at {idx}: ...{src[max(0,idx-60):idx+200]}...")
        else:
            print(f"\n[SRC] '{kw}' NOT FOUND")

    input("\nPress Enter to close...")
finally:
    driver.quit()

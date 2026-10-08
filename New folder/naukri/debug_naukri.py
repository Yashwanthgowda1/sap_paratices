import time
import os
from dotenv import load_dotenv
from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.action_chains import ActionChains

load_dotenv()

EMAIL    = os.getenv("NAUKRI_EMAIL")
PASSWORD = os.getenv("NAUKRI_PASSWORD")
SS_DIR   = "C:/python_study/New folder/naukri/"


def init_driver():
    options = webdriver.ChromeOptions()
    options.add_argument("--start-maximized")
    options.add_argument("--disable-notifications")
    options.add_experimental_option("excludeSwitches", ["enable-automation"])
    options.add_experimental_option("useAutomationExtension", False)
    return webdriver.Chrome(options=options)


def ss(driver, name):
    path = SS_DIR + name + ".png"
    driver.save_screenshot(path)
    print(f"    [screenshot] {path}")


def login(driver, wait):
    driver.get("https://www.naukri.com/nlogin/login")
    time.sleep(3)
    wait.until(EC.presence_of_element_located((By.ID, "usernameField"))).send_keys(EMAIL)
    driver.find_element(By.ID, "passwordField").send_keys(PASSWORD)
    driver.find_element(By.XPATH, "//button[@type='submit']").click()
    time.sleep(5)
    print("[+] Logged in.")


def main():
    driver = init_driver()
    wait   = WebDriverWait(driver, 15)

    try:
        login(driver, wait)
        driver.get("https://www.naukri.com/")
        time.sleep(4)
        ss(driver, "01_homepage")

        # Step 1: Click the expand button (nI-gNb-sb__expand) to show the search bar
        print("\n[Step 1] Clicking search expand button...")
        try:
            expand_btn = driver.find_element(By.CLASS_NAME, "nI-gNb-sb__expand")
            expand_btn.click()
            time.sleep(2)
            ss(driver, "02_after_expand")
            print("    [+] Expand clicked.")
        except Exception as e:
            print(f"    [!] Expand btn error: {e}")
            ss(driver, "02_expand_failed")

        # Step 2: Dump inputs again after expand
        print("\n[Step 2] Inputs after expand:")
        for i, inp in enumerate(driver.find_elements(By.TAG_NAME, "input")):
            print(f"  [{i}] id={inp.get_attribute('id')!r} "
                  f"placeholder={inp.get_attribute('placeholder')!r} "
                  f"displayed={inp.is_displayed()} enabled={inp.is_enabled()}")

        # Step 3: Click and type in search box
        print("\n[Step 3] Typing in search box...")
        try:
            box = wait.until(EC.element_to_be_clickable(
                (By.XPATH, "//input[@placeholder='Enter keyword / designation / companies' and not(@disabled)]")
            ))
            box.click()
            time.sleep(0.5)
            ActionChains(driver).key_down(Keys.CONTROL).send_keys("a").key_up(Keys.CONTROL).perform()
            box.send_keys(Keys.DELETE)
            box.send_keys("SDET")
            time.sleep(2)
            ss(driver, "03_after_typing")
            print("    [+] Typed SDET.")
        except Exception as e:
            print(f"    [!] Typing failed: {e}")
            ss(driver, "03_typing_failed")

        # Step 4: Set experience
        print("\n[Step 4] Setting experience...")
        try:
            exp = wait.until(EC.element_to_be_clickable((By.ID, "experienceDD")))
            exp.click()
            time.sleep(0.5)
            ActionChains(driver).key_down(Keys.CONTROL).send_keys("a").key_up(Keys.CONTROL).perform()
            exp.send_keys(Keys.DELETE)
            exp.send_keys("3")
            time.sleep(1)
            ss(driver, "04_after_experience")
            # Pick option
            try:
                opt = WebDriverWait(driver, 3).until(EC.element_to_be_clickable(
                    (By.XPATH, "//li[normalize-space(text())='3' or starts-with(normalize-space(text()),'3 ')]")
                ))
                opt.click()
                print("    [+] Experience 3 selected from dropdown.")
            except Exception:
                exp.send_keys(Keys.RETURN)
                print("    [+] Experience set via Enter.")
            time.sleep(1)
            ss(driver, "05_after_experience_set")
        except Exception as e:
            print(f"    [!] Experience failed: {e}")
            ss(driver, "04_experience_failed")

        # Step 5: Click Search
        print("\n[Step 5] Clicking Search button...")
        try:
            search_btn = driver.find_element(By.CLASS_NAME, "nI-gNb-sb__icon-wrapper")
            search_btn.click()
            time.sleep(4)
            ss(driver, "06_search_results")
            print(f"    [+] Results URL: {driver.current_url}")
        except Exception as e:
            print(f"    [!] Search btn failed: {e}")
            ss(driver, "06_search_failed")
            # Fallback: press Enter in search box
            try:
                box = driver.find_element(By.XPATH,
                    "//input[@placeholder='Enter keyword / designation / companies']")
                box.send_keys(Keys.RETURN)
                time.sleep(4)
                ss(driver, "06b_search_enter_fallback")
                print(f"    [+] Fallback URL: {driver.current_url}")
            except Exception as e2:
                print(f"    [!] Fallback also failed: {e2}")

        input("\nPress Enter to close...")
    finally:
        driver.quit()


if __name__ == "__main__":
    main()

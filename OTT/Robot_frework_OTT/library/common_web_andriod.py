import json, os, time
from collections import OrderedDict

from selenium.webdriver.common.by import By
from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

from library.initialize_browser import InitializeBrowser
from library.Setuputility import SetupUtility

from robot.api.deco import keyword
from robot.api import logger

# Global driver
driver = None


def load_locators(file_path):
    """Load locators from a JSON file."""
    abs_path = os.path.abspath(file_path)
    if not os.path.exists(abs_path):
        raise FileNotFoundError(f"[ERROR] Locator file not found: {abs_path}")
    if os.path.getsize(abs_path) == 0:
        raise ValueError(f"[ERROR] Locator file is empty: {abs_path}")
    with open(abs_path, "r", encoding="utf-8") as f:
        # this method will help to load the json data which can handle high loads of data can check why diff in the chatgpt
        return json.load(f, object_hook=OrderedDict)


@keyword
def initialize_driver(device_type="web", browser="chrome"):
    """Initialize driver once for web or Android."""
    global driver
    if driver is not None:   # ✅ Prevent multiple launches
        return driver

    device_type = device_type.strip('"').strip("'")
    if device_type.lower() in ["android", "real_device", "emulator"]:
        driver = SetupUtility().connect_device(device_type=device_type)
    elif device_type.lower() == "web":
        driver = InitializeBrowser().initialize_browser(browser_name=browser)
    else:
        raise ValueError(f"Unsupported device type: {device_type}")
    return driver


def take_screenshot_on_error(message):
    """Take a screenshot and log it in Robot Framework report."""
    global driver
    timestamp = time.strftime("%Y%m%d-%H%M%S")
    screenshot_name = f"screenshot_{timestamp}.png"
    screenshot_path = os.path.join(os.getcwd(), screenshot_name)
    if driver:
        driver.save_screenshot(screenshot_path)
        logger.error(message)
        logger.info(
            f'<a href="{screenshot_name}"><img src="{screenshot_name}" width="800px"></a>',
            html=True
        )
    else:
        logger.error("Driver not initialized, cannot take screenshot.")


def find_element(device_type, locator_dict, locator_key, timeout=10):
    """Find an element with WebDriverWait and locator strategies."""
    global driver
    try:
        if driver is None:
            raise Exception("Driver not initialized. Call 'Initialize Driver' first.")  # ✅ stop duplicate launch
        if locator_key not in locator_dict:
            raise KeyError(f"Locator '{locator_key}' not found in {locator_dict}")

        locator_all_keypairs = locator_dict[locator_key]

        by_type_android = {
            "id": AppiumBy.ID,
            "xpath": AppiumBy.XPATH,
            "accessibility_id": AppiumBy.ACCESSIBILITY_ID,
            "class_name": AppiumBy.CLASS_NAME,
            "android_ui_automator": AppiumBy.ANDROID_UIAUTOMATOR
        }
        by_type_web = {
            "id": By.ID,
            "xpath": By.XPATH,
            "text": By.LINK_TEXT,
            "css": By.CSS_SELECTOR
        }

        by_type_choice = (
            by_type_android if device_type.lower() in ["android", "real_device", "emulator"]
            else by_type_web
        )

        for loc_key, loc_value in locator_all_keypairs.items():
            value_of_choice = by_type_choice.get(loc_key.lower())
            if value_of_choice:
                try:

                    return WebDriverWait(driver, timeout).until(
                        EC.presence_of_element_located((value_of_choice, loc_value))
                    )
                except Exception:
                    continue

        raise Exception(f"Element '{locator_key}' not found with any locator strategy.")

    except Exception as e:
        take_screenshot_on_error(f"Error finding element '{locator_key}': {e}")
        raise e


@keyword
def go_to_url(url):
    """Navigate to given URL."""
    global driver
    if driver is None:
        raise Exception("Driver not initialized. Call 'Initialize Driver' first.")
    driver.get(url)


@keyword
def close_browser():
    """Close the browser session."""
    global driver
    if driver:
        driver.quit()
        driver = None


@keyword
def quit_driver():
    """Quit driver if running."""
    global driver
    if driver:
        try:
            driver.quit()
            print("[INFO] Driver quit successfully.")
        except Exception as e:
            print(f"[ERROR] Error while quitting driver: {e}")
        finally:
            driver = None

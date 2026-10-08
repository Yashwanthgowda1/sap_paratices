from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
import allure

from config.config import Config
from utilities.wait_helper import WaitHelper
from utilities.screenshot_util import ScreenshotUtil
from utilities.logger import get_logger

log = get_logger(__name__)


class BasePage:
    """All page objects inherit from this class. Wraps common Selenium interactions."""

    def __init__(self, driver):
        self.driver = driver
        self.wait = WaitHelper(driver)
        self.screenshot = ScreenshotUtil(driver)
        self.actions = ActionChains(driver)

    # ── Navigation ────────────────────────────────────────────────────────────
    def open(self, url: str = None):
        target = url or Config.BASE_URL
        log.info(f"Navigate: {target}")
        self.driver.get(target)

    def get_current_url(self) -> str:
        return self.driver.current_url

    def get_title(self) -> str:
        return self.driver.title

    def refresh(self):
        self.driver.refresh()

    def go_back(self):
        self.driver.back()

    # ── Element interactions ───────────────────────────────────────────────────
    def click(self, locator: tuple):
        with allure.step(f"Click: {locator[1]}"):
            self.wait.wait_for_element_clickable(locator).click()

    def type_text(self, locator: tuple, text: str, clear: bool = True):
        with allure.step(f"Type '{text}' into {locator[1]}"):
            el = self.wait.wait_for_element_visible(locator)
            if clear:
                el.clear()
            el.send_keys(text)

    def get_text(self, locator: tuple) -> str:
        return self.wait.wait_for_element_visible(locator).text

    def get_attribute(self, locator: tuple, attr: str) -> str:
        return self.wait.wait_for_element_present(locator).get_attribute(attr)

    def is_displayed(self, locator: tuple) -> bool:
        try:
            return self.wait.wait_for_element_visible(locator).is_displayed()
        except Exception:
            return False

    def is_enabled(self, locator: tuple) -> bool:
        try:
            return self.driver.find_element(*locator).is_enabled()
        except Exception:
            return False

    def get_all_elements(self, locator: tuple) -> list:
        return self.wait.wait_for_all_elements_visible(locator)

    def scroll_to_element(self, locator: tuple):
        el = self.wait.wait_for_element_present(locator)
        self.driver.execute_script("arguments[0].scrollIntoView({behavior:'smooth',block:'center'});", el)

    def scroll_to_bottom(self):
        self.driver.execute_script("window.scrollTo(0, document.body.scrollHeight);")

    def hover(self, locator: tuple):
        el = self.wait.wait_for_element_visible(locator)
        self.actions.move_to_element(el).perform()

    def press_key(self, locator: tuple, key):
        self.wait.wait_for_element_visible(locator).send_keys(key)

    def js_click(self, locator: tuple):
        el = self.wait.wait_for_element_present(locator)
        self.driver.execute_script("arguments[0].click();", el)

    def switch_to_frame(self, locator: tuple):
        el = self.wait.wait_for_element_present(locator)
        self.driver.switch_to.frame(el)

    def switch_to_default_content(self):
        self.driver.switch_to.default_content()

    def accept_alert(self):
        WebDriverWait(self.driver, Config.EXPLICIT_WAIT).until(EC.alert_is_present())
        self.driver.switch_to.alert.accept()

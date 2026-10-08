from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import TimeoutException
from selenium.webdriver.remote.webdriver import WebDriver
from utilities.logger import get_logger

log = get_logger(__name__)


class WaitHelper:
    def __init__(self, driver: WebDriver, default_timeout: int = 15):
        self.driver = driver
        self.default_timeout = default_timeout

    def wait_for_element_visible(self, locator: tuple, timeout: int = None):
        t = timeout or self.default_timeout
        try:
            return WebDriverWait(self.driver, t).until(EC.visibility_of_element_located(locator))
        except TimeoutException:
            log.warning(f"Element not visible after {t}s: {locator}")
            return None

    def wait_for_element_clickable(self, locator: tuple, timeout: int = None):
        t = timeout or self.default_timeout
        try:
            return WebDriverWait(self.driver, t).until(EC.element_to_be_clickable(locator))
        except TimeoutException:
            log.warning(f"Element not clickable after {t}s: {locator}")
            return None

    def wait_for_url_contains(self, fragment: str, timeout: int = None) -> bool:
        t = timeout or self.default_timeout
        try:
            WebDriverWait(self.driver, t).until(EC.url_contains(fragment))
            return True
        except TimeoutException:
            log.warning(f"URL did not contain '{fragment}' after {t}s")
            return False

    def wait_for_text_in_element(self, locator: tuple, text: str, timeout: int = None) -> bool:
        t = timeout or self.default_timeout
        try:
            WebDriverWait(self.driver, t).until(EC.text_to_be_present_in_element(locator, text))
            return True
        except TimeoutException:
            log.warning(f"Text '{text}' not found in {locator} after {t}s")
            return False

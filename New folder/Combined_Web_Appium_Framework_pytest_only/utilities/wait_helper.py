from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from utilities.logger import get_logger

log = get_logger(__name__)


class WaitHelper:
    """
    Explicit wait helper — works for both Selenium (web) and Appium (mobile).
    Explicit waits are always preferred over time.sleep() in industry.

    Why: time.sleep(5) always waits 5 seconds even if element appears in 1s.
         WebDriverWait polls every 0.5s and returns as soon as condition is met.
    """

    def __init__(self, driver, timeout: int = 15):
        self.driver  = driver
        self.timeout = timeout
        self.wait    = WebDriverWait(driver, timeout)

    def wait_for_element_visible(self, locator: tuple):
        """Wait until element is visible on screen. locator = (By.ID, "value")"""
        log.debug(f"Waiting for visible: {locator}")
        return self.wait.until(EC.visibility_of_element_located(locator))

    def wait_for_element_clickable(self, locator: tuple):
        """Wait until element is visible AND enabled (ready to click)."""
        log.debug(f"Waiting for clickable: {locator}")
        return self.wait.until(EC.element_to_be_clickable(locator))

    def wait_for_element_present(self, locator: tuple):
        """Wait until element exists in DOM (may be hidden)."""
        log.debug(f"Waiting for present in DOM: {locator}")
        return self.wait.until(EC.presence_of_element_located(locator))

    def wait_for_text_in_element(self, locator: tuple, text: str):
        """Wait until element contains expected text."""
        log.debug(f"Waiting for text '{text}' in {locator}")
        return self.wait.until(EC.text_to_be_present_in_element(locator, text))

    def wait_for_url_contains(self, partial_url: str):
        """Wait until browser URL contains expected string."""
        log.debug(f"Waiting for URL to contain: {partial_url}")
        return self.wait.until(EC.url_contains(partial_url))

    def wait_for_element_invisible(self, locator: tuple):
        """Wait until element disappears — useful for loading spinners."""
        log.debug(f"Waiting for invisible: {locator}")
        return self.wait.until(EC.invisibility_of_element_located(locator))

    def is_element_present(self, locator: tuple) -> bool:
        """Non-blocking check — returns True/False immediately. No exception."""
        try:
            WebDriverWait(self.driver, 3).until(EC.presence_of_element_located(locator))
            return True
        except TimeoutException:
            return False

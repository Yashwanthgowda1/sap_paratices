from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException, NoSuchElementException

from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)


class WaitHelper:
    def __init__(self, driver, timeout: int = None):
        self.driver = driver
        self.timeout = timeout or Config.EXPLICIT_WAIT

    def wait_for_element_visible(self, locator: tuple, timeout: int = None):
        try:
            return WebDriverWait(self.driver, timeout or self.timeout).until(
                EC.visibility_of_element_located(locator)
            )
        except TimeoutException:
            log.error(f"Element not visible after {timeout or self.timeout}s: {locator}")
            raise

    def wait_for_element_clickable(self, locator: tuple, timeout: int = None):
        try:
            return WebDriverWait(self.driver, timeout or self.timeout).until(
                EC.element_to_be_clickable(locator)
            )
        except TimeoutException:
            log.error(f"Element not clickable after {timeout or self.timeout}s: {locator}")
            raise

    def wait_for_element_present(self, locator: tuple, timeout: int = None):
        return WebDriverWait(self.driver, timeout or self.timeout).until(
            EC.presence_of_element_located(locator)
        )

    def wait_for_url_contains(self, partial_url: str, timeout: int = None):
        return WebDriverWait(self.driver, timeout or self.timeout).until(
            EC.url_contains(partial_url)
        )

    def wait_for_title_contains(self, title: str, timeout: int = None):
        return WebDriverWait(self.driver, timeout or self.timeout).until(
            EC.title_contains(title)
        )

    def wait_for_element_invisible(self, locator: tuple, timeout: int = None):
        return WebDriverWait(self.driver, timeout or self.timeout).until(
            EC.invisibility_of_element_located(locator)
        )

    def wait_for_all_elements_visible(self, locator: tuple, timeout: int = None):
        return WebDriverWait(self.driver, timeout or self.timeout).until(
            EC.visibility_of_all_elements_located(locator)
        )

    def is_element_present(self, locator: tuple) -> bool:
        try:
            self.driver.find_element(*locator)
            return True
        except NoSuchElementException:
            return False

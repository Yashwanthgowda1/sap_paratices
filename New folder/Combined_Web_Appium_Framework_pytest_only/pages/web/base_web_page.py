from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.common.exceptions import NoSuchElementException
from utilities.wait_helper import WaitHelper
from utilities.logger import get_logger

log = get_logger(__name__)


class BaseWebPage:
    """
    Parent class for ALL web page objects.
    Contains common browser interactions so child pages don't repeat them.

    Every web page class inherits from this:
        class LoginPage(BaseWebPage): ...
        class HomePage(BaseWebPage): ...
    """

    def __init__(self, driver):
        self.driver = driver
        self.wait   = WaitHelper(driver)

    def open(self, url: str):
        log.info(f"Opening URL: {url}")
        self.driver.get(url)

    def get_title(self) -> str:
        return self.driver.title

    def get_current_url(self) -> str:
        return self.driver.current_url

    def find_element(self, locator: tuple):
        return self.wait.wait_for_element_visible(locator)

    def click(self, locator: tuple):
        log.debug(f"Clicking: {locator}")
        element = self.wait.wait_for_element_clickable(locator)
        element.click()

    def type_text(self, locator: tuple, text: str):
        log.debug(f"Typing '{text}' into {locator}")
        element = self.wait.wait_for_element_visible(locator)
        element.clear()
        element.send_keys(text)

    def get_text(self, locator: tuple) -> str:
        return self.find_element(locator).text

    def is_displayed(self, locator: tuple) -> bool:
        try:
            return self.driver.find_element(*locator).is_displayed()
        except NoSuchElementException:
            return False

    def scroll_to_element(self, locator: tuple):
        element = self.find_element(locator)
        self.driver.execute_script("arguments[0].scrollIntoView(true);", element)

    def wait_for_page_load(self):
        self.wait.wait_for_url_contains("")  # just waits for any URL to be set
        self.driver.execute_script("return document.readyState") == "complete"

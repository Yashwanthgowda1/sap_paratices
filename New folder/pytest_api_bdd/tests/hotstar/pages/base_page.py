"""
pages/base_page.py
------------------
All page classes inherit from this.
Common browser actions (click, type, wait, scroll) live here once.
Individual pages only define their own locators and steps.
"""

from selenium.webdriver.remote.webdriver import WebDriver
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.by import By
from selenium.common.exceptions import TimeoutException


class BasePage:

    TIMEOUT = 15   # seconds to wait for elements

    def __init__(self, driver: WebDriver):
        self.driver = driver
        self.wait   = WebDriverWait(driver, self.TIMEOUT)

    # ── Navigation ────────────────────────────────────────────────────────────

    def open(self, url: str):
        self.driver.get(url)

    def get_title(self) -> str:
        return self.driver.title

    def get_current_url(self) -> str:
        return self.driver.current_url

    # ── Wait helpers ──────────────────────────────────────────────────────────

    def wait_for_element(self, by: By, locator: str):
        return self.wait.until(
            EC.presence_of_element_located((by, locator)),
            message=f"Element not found: {locator}"
        )

    def wait_for_clickable(self, by: By, locator: str):
        return self.wait.until(
            EC.element_to_be_clickable((by, locator)),
            message=f"Element not clickable: {locator}"
        )

    def wait_for_visible(self, by: By, locator: str):
        return self.wait.until(
            EC.visibility_of_element_located((by, locator)),
            message=f"Element not visible: {locator}"
        )

    def is_element_visible(self, by: By, locator: str) -> bool:
        try:
            return self.wait_for_visible(by, locator).is_displayed()
        except TimeoutException:
            return False

    # ── Actions ───────────────────────────────────────────────────────────────

    def click(self, by: By, locator: str):
        self.wait_for_clickable(by, locator).click()

    def type_text(self, by: By, locator: str, text: str):
        element = self.wait_for_element(by, locator)
        element.clear()
        element.send_keys(text)

    def get_text(self, by: By, locator: str) -> str:
        return self.wait_for_visible(by, locator).text

    def scroll_down(self):
        self.driver.execute_script("window.scrollBy(0, 500)")

    def scroll_to_element(self, by: By, locator: str):
        element = self.wait_for_element(by, locator)
        self.driver.execute_script("arguments[0].scrollIntoView(true);", element)

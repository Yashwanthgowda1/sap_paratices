from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from config.config import Config


class WaitHelper:
    def __init__(self, driver, timeout: int = None):
        self.driver = driver
        self.timeout = timeout or Config.EXPLICIT_WAIT
        self._wait = WebDriverWait(driver, self.timeout)

    def wait_for_element_visible(self, locator: tuple):
        return self._wait.until(EC.visibility_of_element_located(locator))

    def wait_for_element_present(self, locator: tuple):
        return self._wait.until(EC.presence_of_element_located(locator))

    def wait_for_element_clickable(self, locator: tuple):
        return self._wait.until(EC.element_to_be_clickable(locator))

    def wait_for_all_elements_visible(self, locator: tuple) -> list:
        return self._wait.until(EC.visibility_of_all_elements_located(locator))

    def wait_for_url_contains(self, fragment: str):
        return self._wait.until(EC.url_contains(fragment))

    def wait_for_title_contains(self, title: str):
        return self._wait.until(EC.title_contains(title))

    def wait_for_element_invisible(self, locator: tuple):
        return self._wait.until(EC.invisibility_of_element_located(locator))

    def wait_for_text_in_element(self, locator: tuple, text: str):
        return self._wait.until(EC.text_to_be_present_in_element(locator, text))

    def is_element_present(self, locator: tuple, timeout: int = 3) -> bool:
        try:
            WebDriverWait(self.driver, timeout).until(EC.presence_of_element_located(locator))
            return True
        except Exception:
            return False

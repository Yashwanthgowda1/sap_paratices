from selenium.webdriver.remote.webdriver import WebDriver
from selenium.webdriver.remote.webelement import WebElement
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.common.action_chains import ActionChains
from selenium.common.exceptions import TimeoutException, NoSuchElementException
from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)


class BasePage:
    def __init__(self, driver: WebDriver):
        self.driver = driver
        self.wait = WebDriverWait(driver, Config.EXPLICIT_WAIT)
        self.driver.implicitly_wait(Config.IMPLICIT_WAIT)
        self.driver.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)

    def open(self, url: str = None):
        target = url or Config.BASE_URL
        log.info(f"Navigating to {target}")
        self.driver.get(target)

    def click(self, locator: tuple):
        element = self.wait.until(EC.element_to_be_clickable(locator))
        log.debug(f"Clicking: {locator}")
        element.click()

    def type_text(self, locator: tuple, text: str):
        element = self.wait.until(EC.visibility_of_element_located(locator))
        element.clear()
        element.send_keys(text)
        log.debug(f"Typed '{text}' into {locator}")

    def get_text(self, locator: tuple) -> str:
        element = self.wait.until(EC.visibility_of_element_located(locator))
        return element.text.strip()

    def is_displayed(self, locator: tuple, timeout: int = None) -> bool:
        t = timeout or Config.EXPLICIT_WAIT
        try:
            WebDriverWait(self.driver, t).until(EC.visibility_of_element_located(locator))
            return True
        except TimeoutException:
            return False

    def wait_for_url_contains(self, fragment: str, timeout: int = None):
        t = timeout or Config.EXPLICIT_WAIT
        WebDriverWait(self.driver, t).until(EC.url_contains(fragment))

    def find_elements(self, locator: tuple) -> list:
        try:
            return self.wait.until(EC.presence_of_all_elements_located(locator))
        except TimeoutException:
            return []

    def scroll_to(self, element: WebElement):
        self.driver.execute_script("arguments[0].scrollIntoView({behavior:'smooth',block:'center'});", element)

    def hover(self, locator: tuple):
        element = self.wait.until(EC.visibility_of_element_located(locator))
        ActionChains(self.driver).move_to_element(element).perform()

    def get_attribute(self, locator: tuple, attribute: str) -> str:
        element = self.wait.until(EC.presence_of_element_located(locator))
        return element.get_attribute(attribute) or ""

    def js_click(self, locator: tuple):
        element = self.wait.until(EC.presence_of_element_located(locator))
        self.driver.execute_script("arguments[0].click();", element)

from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.edge.options import Options as EdgeOptions
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.edge.service import Service as EdgeService
from webdriver_manager.chrome import ChromeDriverManager
from webdriver_manager.firefox import GeckoDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager

from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)


class DriverFactory:
    """Creates and configures WebDriver instances."""

    @staticmethod
    def get_driver(browser: str = None, headless: bool = None) -> webdriver.Remote:
        browser = (browser or Config.BROWSER).lower()
        headless = headless if headless is not None else Config.HEADLESS

        log.info(f"Initialising browser: {browser} | headless={headless}")

        if browser == "chrome":
            return DriverFactory._chrome(headless)
        elif browser == "firefox":
            return DriverFactory._firefox(headless)
        elif browser == "edge":
            return DriverFactory._edge(headless)
        else:
            raise ValueError(f"Unsupported browser: {browser}. Choose chrome | firefox | edge")

    @staticmethod
    def _chrome(headless: bool) -> webdriver.Chrome:
        opts = ChromeOptions()
        if headless:
            opts.add_argument("--headless=new")
        opts.add_argument("--no-sandbox")
        opts.add_argument("--disable-dev-shm-usage")
        opts.add_argument("--disable-notifications")
        opts.add_argument("--disable-popup-blocking")
        opts.add_argument("--start-maximized")
        opts.add_argument("--disable-infobars")
        opts.add_experimental_option("excludeSwitches", ["enable-automation"])
        opts.add_experimental_option("useAutomationExtension", False)
        service = ChromeService(ChromeDriverManager().install())
        driver = webdriver.Chrome(service=service, options=opts)
        driver.implicitly_wait(Config.IMPLICIT_WAIT)
        driver.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)
        return driver

    @staticmethod
    def _firefox(headless: bool) -> webdriver.Firefox:
        opts = FirefoxOptions()
        if headless:
            opts.add_argument("--headless")
        service = FirefoxService(GeckoDriverManager().install())
        driver = webdriver.Firefox(service=service, options=opts)
        driver.implicitly_wait(Config.IMPLICIT_WAIT)
        driver.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)
        driver.maximize_window()
        return driver

    @staticmethod
    def _edge(headless: bool) -> webdriver.Edge:
        opts = EdgeOptions()
        if headless:
            opts.add_argument("--headless=new")
        opts.add_argument("--start-maximized")
        service = EdgeService(EdgeChromiumDriverManager().install())
        driver = webdriver.Edge(service=service, options=opts)
        driver.implicitly_wait(Config.IMPLICIT_WAIT)
        driver.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)
        return driver

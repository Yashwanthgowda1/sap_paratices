from selenium import webdriver
from selenium.webdriver.chrome.options import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.edge.options import Options as EdgeOptions

from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)


class DriverFactory:
    @staticmethod
    def get_driver(browser: str = None, headless: bool = False) -> webdriver.Remote:
        browser = (browser or Config.BROWSER).lower()
        log.info(f"Initialising {browser} driver | headless={headless}")

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
        opts.add_argument("--start-maximized")
        opts.add_argument("--disable-notifications")
        opts.add_argument("--disable-popup-blocking")
        opts.add_argument("--no-sandbox")
        opts.add_argument("--disable-dev-shm-usage")
        if headless:
            opts.add_argument("--headless=new")
            opts.add_argument("--window-size=1920,1080")
        drv = webdriver.Chrome(options=opts)
        drv.implicitly_wait(Config.IMPLICIT_WAIT)
        drv.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)
        return drv

    @staticmethod
    def _firefox(headless: bool) -> webdriver.Firefox:
        opts = FirefoxOptions()
        if headless:
            opts.add_argument("--headless")
        drv = webdriver.Firefox(options=opts)
        drv.maximize_window()
        drv.implicitly_wait(Config.IMPLICIT_WAIT)
        drv.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)
        return drv

    @staticmethod
    def _edge(headless: bool) -> webdriver.Edge:
        opts = EdgeOptions()
        opts.add_argument("--start-maximized")
        if headless:
            opts.add_argument("--headless=new")
            opts.add_argument("--window-size=1920,1080")
        drv = webdriver.Edge(options=opts)
        drv.implicitly_wait(Config.IMPLICIT_WAIT)
        drv.set_page_load_timeout(Config.PAGE_LOAD_TIMEOUT)
        return drv

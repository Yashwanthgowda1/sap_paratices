from selenium import webdriver
from selenium.webdriver.chrome.service  import Service as ChromeService
from selenium.webdriver.firefox.service import Service as FirefoxService
from selenium.webdriver.edge.service    import Service as EdgeService
from selenium.webdriver.chrome.options  import Options as ChromeOptions
from selenium.webdriver.firefox.options import Options as FirefoxOptions
from selenium.webdriver.edge.options    import Options as EdgeOptions
from webdriver_manager.chrome    import ChromeDriverManager
from webdriver_manager.firefox   import GeckoDriverManager
from webdriver_manager.microsoft import EdgeChromiumDriverManager
from utilities.logger import get_logger

log = get_logger(__name__)


class WebDriverFactory:
    """
    Creates and returns a Selenium WebDriver instance.
    Supports: chrome | firefox | edge  (headless mode for each)
    """

    @staticmethod
    def get_driver(browser: str = "chrome", headless: bool = False):
        browser = browser.lower().strip()
        log.info(f"[WEB] Launching '{browser}' browser  headless={headless}")

        if browser == "chrome":
            opts = ChromeOptions()
            if headless:
                opts.add_argument("--headless=new")          # Chrome v112+ headless flag
            opts.add_argument("--no-sandbox")                # Required in Docker/Linux CI
            opts.add_argument("--disable-dev-shm-usage")     # Prevents memory issues in CI
            opts.add_argument("--window-size=1920,1080")
            opts.add_argument("--disable-blink-features=AutomationControlled")
            opts.add_experimental_option("excludeSwitches", ["enable-automation"])
            return webdriver.Chrome(
                service=ChromeService(ChromeDriverManager().install()),
                options=opts
            )

        if browser == "firefox":
            opts = FirefoxOptions()
            if headless:
                opts.add_argument("--headless")
            return webdriver.Firefox(
                service=FirefoxService(GeckoDriverManager().install()),
                options=opts
            )

        if browser == "edge":
            opts = EdgeOptions()
            if headless:
                opts.add_argument("--headless=new")
            opts.add_argument("--window-size=1920,1080")
            return webdriver.Edge(
                service=EdgeService(EdgeChromiumDriverManager().install()),
                options=opts
            )

        raise ValueError(f"Unsupported browser: '{browser}'. Use: chrome | firefox | edge")

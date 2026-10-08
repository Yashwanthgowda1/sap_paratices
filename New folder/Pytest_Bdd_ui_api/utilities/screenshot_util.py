import os
from datetime import datetime
from pathlib import Path
from selenium.webdriver.remote.webdriver import WebDriver
from utilities.logger import get_logger

log = get_logger(__name__)

_SCREENSHOTS_DIR = Path(__file__).resolve().parent.parent / "reports" / "screenshots"
_SCREENSHOTS_DIR.mkdir(parents=True, exist_ok=True)


class ScreenshotUtil:
    def __init__(self, driver: WebDriver):
        self.driver = driver

    def take_screenshot_on_failure(self, test_name: str) -> str:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_name = "".join(c if c.isalnum() or c in "-_" else "_" for c in test_name)
        filename = f"{safe_name}_{timestamp}.png"
        path = str(_SCREENSHOTS_DIR / filename)
        try:
            self.driver.save_screenshot(path)
            log.info(f"Screenshot saved: {path}")
        except Exception as e:
            log.warning(f"Could not save screenshot: {e}")
        return path

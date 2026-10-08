import os
from datetime import datetime
from pathlib import Path
from utilities.logger import get_logger

log = get_logger(__name__)

SCREENSHOT_DIR = Path(__file__).parent.parent / "screenshots"
SCREENSHOT_DIR.mkdir(exist_ok=True)


class ScreenshotUtil:
    """
    Captures screenshots for both Selenium (web) and Appium (mobile).
    The driver.save_screenshot() API is identical for both.
    """

    def __init__(self, driver):
        self.driver = driver

    def take_screenshot(self, name: str) -> str:
        """Save screenshot with timestamp. Returns file path."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename  = f"{name}_{timestamp}.png"
        filepath  = SCREENSHOT_DIR / filename
        self.driver.save_screenshot(str(filepath))
        log.info(f"[SCREENSHOT] Saved: {filepath}")
        return str(filepath)

    def take_screenshot_on_failure(self, test_name: str) -> str:
        """Called automatically by conftest on test failure."""
        log.warning(f"[SCREENSHOT] Capturing failure screenshot for: {test_name}")
        return self.take_screenshot(f"FAILED_{test_name}")

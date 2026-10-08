import os
from datetime import datetime
from pathlib import Path

from config.config import Config
from utilities.logger import get_logger

log = get_logger(__name__)


class ScreenshotUtil:
    def __init__(self, driver):
        self.driver = driver
        self.screenshots_dir = Config.SCREENSHOTS_DIR
        self.screenshots_dir.mkdir(parents=True, exist_ok=True)

    def take_screenshot(self, name: str = "screenshot") -> str:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"{name}_{timestamp}.png"
        path = self.screenshots_dir / filename
        self.driver.save_screenshot(str(path))
        log.info(f"Screenshot saved: {path}")
        return str(path)

    def take_screenshot_on_failure(self, test_name: str) -> str:
        return self.take_screenshot(f"FAIL_{test_name}")

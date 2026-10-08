from appium import webdriver as appium_webdriver
from appium.options import AppiumOptions
from config.config import MobileConfig
from utilities.logger import get_logger

log = get_logger(__name__)


class MobileDriverFactory:
    """
    Creates and returns an Appium WebDriver connected to an Android device.
    Appium server must already be running at MobileConfig.APPIUM_URL.

    How it works:
      1. Builds AppiumOptions from MobileConfig.CAPABILITIES dict
      2. Connects to Appium server via HTTP
      3. Appium server talks to Android device via ADB
      4. Returns driver — same WebDriver API as Selenium
    """

    @staticmethod
    def get_driver() -> appium_webdriver.Remote:
        log.info(f"[MOBILE] Connecting to Appium at {MobileConfig.APPIUM_URL}")
        log.info(f"[MOBILE] Device: {MobileConfig.CAPABILITIES.get('appium:deviceName')}")
        log.info(f"[MOBILE] App:    {MobileConfig.CAPABILITIES.get('appium:app')}")

        options = AppiumOptions()
        for key, value in MobileConfig.CAPABILITIES.items():
            options.set_capability(key, value)

        driver = appium_webdriver.Remote(
            command_executor=MobileConfig.APPIUM_URL,
            options=options
        )

        driver.implicitly_wait(MobileConfig.IMPLICIT_WAIT)
        log.info("[MOBILE] Appium driver created successfully")
        return driver

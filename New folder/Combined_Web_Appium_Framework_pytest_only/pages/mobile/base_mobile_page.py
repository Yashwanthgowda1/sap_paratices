from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium.common.exceptions import NoSuchElementException
from utilities.wait_helper import WaitHelper
from utilities.gesture_helper import GestureHelper
from utilities.logger import get_logger

log = get_logger(__name__)


class BaseMobilePage:
    """
    Parent class for ALL mobile page objects.
    Provides element interactions + gesture support.

    Key difference from BaseWebPage:
      - Uses AppiumBy locators (ACCESSIBILITY_ID, ANDROID_UIAUTOMATOR, etc.)
      - Has GestureHelper for scroll/swipe/long-press
      - Uses mobile-specific waits (apps load slower than websites)
    """

    def __init__(self, driver):
        self.driver  = driver
        self.wait    = WaitHelper(driver, timeout=20)     # longer timeout for mobile
        self.gesture = GestureHelper(driver)

    # ── Element interactions ──────────────────────────────────────────────────

    def find_element(self, locator: tuple):
        return self.wait.wait_for_element_visible(locator)

    def click(self, locator: tuple):
        log.debug(f"[MOBILE] Clicking: {locator}")
        element = self.wait.wait_for_element_clickable(locator)
        element.click()

    def type_text(self, locator: tuple, text: str):
        log.debug(f"[MOBILE] Typing '{text}' into {locator}")
        element = self.wait.wait_for_element_visible(locator)
        element.clear()
        element.send_keys(text)

    def get_text(self, locator: tuple) -> str:
        return self.find_element(locator).text

    def is_displayed(self, locator: tuple) -> bool:
        try:
            return self.driver.find_element(*locator).is_displayed()
        except NoSuchElementException:
            return False

    def get_attribute(self, locator: tuple, attr: str) -> str:
        """Get element attribute — e.g. content-desc, text, resource-id."""
        return self.find_element(locator).get_attribute(attr)

    # ── App control ───────────────────────────────────────────────────────────

    def press_back(self):
        """Press Android hardware back button."""
        log.debug("[MOBILE] Pressing back button")
        self.driver.back()

    def press_home(self):
        """Press Android home button — goes to device home screen."""
        from appium.webdriver.extensions.android.nativekey import AndroidKey
        self.driver.press_keycode(AndroidKey.HOME)

    def hide_keyboard(self):
        """Dismiss software keyboard if visible."""
        try:
            self.driver.hide_keyboard()
        except Exception:
            pass  # keyboard already hidden — safe to ignore

    def get_app_state(self) -> int:
        """
        Returns app state:
          0 = not installed
          1 = not running
          3 = running in background
          4 = running in foreground
        """
        from config.config import MobileConfig
        pkg = MobileConfig.CAPABILITIES.get("appium:appPackage")
        return self.driver.query_app_state(pkg)

    def wait_for_app_foreground(self):
        """Wait until app is in foreground (state=4)."""
        from config.config import MobileConfig
        pkg = MobileConfig.CAPABILITIES.get("appium:appPackage")
        WebDriverWait(self.driver, 15).until(
            lambda d: d.query_app_state(pkg) == 4
        )



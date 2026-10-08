from appium.webdriver.common.appiumby import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from utilities.logger import get_logger

log = get_logger(__name__)


class GestureHelper:
    """
    Mobile gesture library — scroll, swipe, tap, long press, pinch/zoom.
    All gestures use Appium's W3C Actions API (replaces deprecated TouchAction).

    How coordinates work:
        (0,0) = top-left of screen
        Screen size example: 1080 x 2340 pixels
        Mid X = 540,  Top area Y = 400,  Bottom area Y = 1800
    """

    def __init__(self, driver):
        self.driver = driver
        size         = driver.get_window_size()
        self.width   = size["width"]
        self.height  = size["height"]
        log.info(f"[GESTURE] Screen size: {self.width} x {self.height}")

    # ── Scroll ────────────────────────────────────────────────────────────────

    def scroll_down(self, distance: float = 0.5):
        """
        Scroll down by a fraction of screen height.
        distance=0.5 means scroll half the screen.
        Uses Appium mobile:scroll command (most reliable cross-device).
        """
        log.debug(f"Scrolling down  distance={distance}")
        start_y = int(self.height * 0.7)
        end_y   = int(self.height * (0.7 - distance))
        mid_x   = self.width // 2
        self._swipe(mid_x, start_y, mid_x, end_y)

    def scroll_up(self, distance: float = 0.5):
        """Scroll up by a fraction of screen height."""
        log.debug(f"Scrolling up  distance={distance}")
        start_y = int(self.height * 0.3)
        end_y   = int(self.height * (0.3 + distance))
        mid_x   = self.width // 2
        self._swipe(mid_x, start_y, mid_x, end_y)

    def scroll_to_element(self, text: str):
        """
        Scroll down until element with matching text is visible.
        Uses UiScrollable — Android-specific, very fast.
        """
        log.debug(f"Scrolling to element with text: '{text}'")
        locator = (
            AppiumBy.ANDROID_UIAUTOMATOR,
            f'new UiScrollable(new UiSelector().scrollable(true))'
            f'.scrollIntoView(new UiSelector().text("{text}"))'
        )
        return self.driver.find_element(*locator)

    # ── Swipe ─────────────────────────────────────────────────────────────────

    def swipe_left(self):
        """Swipe left — navigate to next screen/card."""
        log.debug("Swiping left")
        start_x = int(self.width * 0.8)
        end_x   = int(self.width * 0.2)
        mid_y   = self.height // 2
        self._swipe(start_x, mid_y, end_x, mid_y)

    def swipe_right(self):
        """Swipe right — go back / previous screen."""
        log.debug("Swiping right")
        start_x = int(self.width * 0.2)
        end_x   = int(self.width * 0.8)
        mid_y   = self.height // 2
        self._swipe(start_x, mid_y, end_x, mid_y)

    def swipe_to_element(self, locator: tuple, max_swipes: int = 5):
        """Swipe left repeatedly until element becomes visible."""
        for i in range(max_swipes):
            try:
                el = WebDriverWait(self.driver, 3).until(
                    EC.visibility_of_element_located(locator)
                )
                log.debug(f"Element found after {i} swipes")
                return el
            except Exception:
                log.debug(f"Swipe {i+1}/{max_swipes} — element not yet visible")
                self.swipe_left()
        raise AssertionError(f"Element {locator} not found after {max_swipes} swipes")

    # ── Tap / Long Press ──────────────────────────────────────────────────────

    def tap(self, x: int, y: int):
        """Tap at exact screen coordinates."""
        log.debug(f"Tapping at ({x}, {y})")
        self.driver.execute_script("mobile: tap", {"x": x, "y": y})

    def long_press_element(self, element, duration_ms: int = 1500):
        """Long press on a web element for context menu / drag handles."""
        log.debug(f"Long pressing element for {duration_ms}ms")
        self.driver.execute_script(
            "mobile: longClickGesture",
            {"elementId": element.id, "duration": duration_ms}
        )

    # ── Pinch / Zoom ──────────────────────────────────────────────────────────

    def pinch_zoom_in(self, element):
        """Zoom in on an element (spread fingers gesture)."""
        log.debug("Pinch zoom IN")
        self.driver.execute_script(
            "mobile: pinchOpenGesture",
            {"elementId": element.id, "percent": 0.75}
        )

    def pinch_zoom_out(self, element):
        """Zoom out on an element (pinch fingers together)."""
        log.debug("Pinch zoom OUT")
        self.driver.execute_script(
            "mobile: pinchCloseGesture",
            {"elementId": element.id, "percent": 0.75}
        )

    # ── Internal helper ───────────────────────────────────────────────────────

    def _swipe(self, start_x: int, start_y: int, end_x: int, end_y: int, duration: int = 800):
        """Low-level W3C swipe action."""
        self.driver.execute_script("mobile: swipeGesture", {
            "left":     min(start_x, end_x),
            "top":      min(start_y, end_y),
            "width":    abs(end_x - start_x) or 1,
            "height":   abs(end_y - start_y) or 1,
            "direction": "down" if end_y > start_y else "up"
                         if end_y < start_y else
                         "left" if end_x < start_x else "right",
            "percent":  0.75
        })

from appium.webdriver.common.appiumby import AppiumBy
from pages.mobile.base_mobile_page import BaseMobilePage
from utilities.logger import get_logger

log = get_logger(__name__)


class MobileHomePage(BaseMobilePage):
    """
    Mobile Home Screen — shown after successful login.
    Demonstrates scroll + swipe usage with gestures.
    """

    # ── Locators ──────────────────────────────────────────────────────────────
    HOME_BANNER      = (AppiumBy.ID, "com.myapp.android:id/home_banner")
    SEARCH_ICON      = (AppiumBy.ACCESSIBILITY_ID, "Search")
    PROFILE_ICON     = (AppiumBy.ACCESSIBILITY_ID, "Profile")
    FEATURED_SECTION = (AppiumBy.ID, "com.myapp.android:id/featured_section")
    CAROUSEL_ITEM    = (AppiumBy.ID, "com.myapp.android:id/carousel_item")
    BOTTOM_NAV_HOME  = (AppiumBy.ID, "com.myapp.android:id/nav_home")
    BOTTOM_NAV_SEARCH= (AppiumBy.ID, "com.myapp.android:id/nav_search")

    # ── Actions ───────────────────────────────────────────────────────────────

    def is_home_loaded(self) -> bool:
        return self.is_displayed(self.HOME_BANNER)

    def tap_search(self):
        self.click(self.SEARCH_ICON)
        log.info("[MOBILE] Search icon tapped")

    def tap_profile(self):
        self.click(self.PROFILE_ICON)

    def scroll_down_home(self):
        """Scroll down to see more content on home screen."""
        self.gesture.scroll_down(distance=0.5)
        log.info("[MOBILE] Scrolled down on home screen")

    def scroll_to_section(self, section_text: str):
        """Scroll until a specific section heading is visible."""
        return self.gesture.scroll_to_element(section_text)

    def swipe_carousel_left(self):
        """Swipe left on featured carousel to see next item."""
        self.gesture.swipe_left()
        log.info("[MOBILE] Swiped carousel left")

    def swipe_carousel_right(self):
        """Swipe right on featured carousel to go back."""
        self.gesture.swipe_right()

    def swipe_to_carousel_item(self, locator: tuple):
        """Swipe until a specific carousel item is visible."""
        return self.gesture.swipe_to_element(locator, max_swipes=5)

    def long_press_content_item(self, locator: tuple):
        """Long press a content card to see context menu (save, share)."""
        element = self.find_element(locator)
        self.gesture.long_press_element(element, duration_ms=1500)
        log.info("[MOBILE] Long pressed content item")

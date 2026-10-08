from appium.webdriver.common.appiumby import AppiumBy
from pages.mobile.base_mobile_page import BaseMobilePage
from utilities.logger import get_logger

log = get_logger(__name__)


class MobileSearchPage(BaseMobilePage):
    """
    Mobile Search Screen.
    Demonstrates scroll_to_element and result interactions.
    """

    # ── Locators ──────────────────────────────────────────────────────────────
    SEARCH_INPUT    = (AppiumBy.ID, "com.myapp.android:id/et_search")
    CLEAR_BUTTON    = (AppiumBy.ID, "com.myapp.android:id/btn_clear")
    RESULT_LIST     = (AppiumBy.ID, "com.myapp.android:id/rv_results")
    RESULT_ITEM     = (AppiumBy.XPATH, "//android.widget.TextView[@resource-id='com.myapp.android:id/tv_result_title']")
    NO_RESULTS_TEXT = (AppiumBy.ID, "com.myapp.android:id/tv_no_results")
    FILTER_BUTTON   = (AppiumBy.ACCESSIBILITY_ID, "Filter")

    # ── Actions ───────────────────────────────────────────────────────────────

    def search_for(self, keyword: str):
        log.info(f"[MOBILE] Searching for: '{keyword}'")
        self.type_text(self.SEARCH_INPUT, keyword)
        self.hide_keyboard()

    def clear_search(self):
        self.click(self.CLEAR_BUTTON)

    def get_results_count(self) -> int:
        results = self.driver.find_elements(*self.RESULT_ITEM)
        log.info(f"[MOBILE] Results found: {len(results)}")
        return len(results)

    def get_all_result_titles(self) -> list:
        elements = self.driver.find_elements(*self.RESULT_ITEM)
        return [el.text for el in elements]

    def is_no_results_shown(self) -> bool:
        return self.is_displayed(self.NO_RESULTS_TEXT)

    def scroll_to_result(self, result_text: str):
        """Scroll result list until item with text is visible."""
        return self.gesture.scroll_to_element(result_text)

    def tap_first_result(self):
        results = self.driver.find_elements(*self.RESULT_ITEM)
        if results:
            results[0].click()
            log.info("[MOBILE] Tapped first result")

    def tap_filter(self):
        self.click(self.FILTER_BUTTON)

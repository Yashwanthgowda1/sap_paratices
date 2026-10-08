from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class SearchPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    SEARCH_INPUT       = (By.CSS_SELECTOR, "input[type='search'], input[placeholder*='Search']")
    SEARCH_RESULTS     = (By.CSS_SELECTOR, "[class*='search-result'], [data-testid*='search-result']")
    RESULT_TITLES      = (By.CSS_SELECTOR, "[class*='result-title'], [class*='content-title']")
    NO_RESULTS_MSG     = (By.CSS_SELECTOR, "[class*='no-result'], [data-testid='no-results']")
    TRENDING_ITEMS     = (By.CSS_SELECTOR, "[class*='trending'], [data-testid*='trending']")
    CLEAR_BUTTON       = (By.CSS_SELECTOR, "[aria-label='Clear'], [class*='clear-btn']")
    FIRST_RESULT       = (By.CSS_SELECTOR, "[class*='search-result']:first-child, [data-testid='search-result-0']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def search_for(self, keyword: str):
        log.info(f"Searching: {keyword}")
        self.type_text(self.SEARCH_INPUT, keyword)
        self.press_key(self.SEARCH_INPUT, Keys.RETURN)

    def get_results(self) -> list:
        try:
            return self.get_all_elements(self.SEARCH_RESULTS)
        except Exception:
            return []

    def get_result_titles(self) -> list[str]:
        try:
            return [el.text for el in self.get_all_elements(self.RESULT_TITLES)]
        except Exception:
            return []

    def has_no_results_message(self) -> bool:
        return self.is_displayed(self.NO_RESULTS_MSG)

    def get_trending_items(self) -> list:
        try:
            return self.get_all_elements(self.TRENDING_ITEMS)
        except Exception:
            return []

    def clear_search(self):
        self.click(self.CLEAR_BUTTON)

    def click_first_result(self):
        self.click(self.FIRST_RESULT)

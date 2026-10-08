from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class SearchPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    SEARCH_INPUT        = (By.CSS_SELECTOR, "input[type='search'], input[placeholder*='Search']")
    SEARCH_CLEAR_BTN    = (By.CSS_SELECTOR, "[aria-label='Clear search'], [class*='clear']")
    SEARCH_RESULTS      = (By.CSS_SELECTOR, "[class*='search-result'], [data-testid='search-result']")
    RESULT_CARD         = (By.CSS_SELECTOR, "[class*='card'], [class*='tile']")
    RESULT_TITLE        = (By.CSS_SELECTOR, "[class*='title'], [class*='name']")
    NO_RESULTS_MSG      = (By.XPATH, "//*[contains(text(),'No results') or contains(text(),'not found')]")
    TRENDING_SEARCHES   = (By.CSS_SELECTOR, "[class*='trending'], [data-testid='trending']")
    FILTER_BUTTON       = (By.CSS_SELECTOR, "[aria-label='Filter'], [data-testid='filter-btn']")
    GENRE_FILTER        = (By.XPATH, "//button[contains(@class,'filter') and contains(text(),'Genre')]")
    LANGUAGE_FILTER     = (By.XPATH, "//button[contains(@class,'filter') and contains(text(),'Language')]")
    SORT_DROPDOWN       = (By.CSS_SELECTOR, "[data-testid='sort-dropdown']")
    RESULT_COUNT        = (By.CSS_SELECTOR, "[class*='result-count'], [data-testid='result-count']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def search(self, keyword: str):
        log.info(f"Searching for: {keyword}")
        self.type_text(self.SEARCH_INPUT, keyword)
        self.press_key(self.SEARCH_INPUT, Keys.ENTER)

    def clear_search(self):
        self.click(self.SEARCH_CLEAR_BTN)

    def get_search_results(self) -> list:
        return self.get_all_elements(self.SEARCH_RESULTS)

    def get_result_titles(self) -> list[str]:
        return [el.text for el in self.get_all_elements(self.RESULT_TITLE)]

    def has_no_results(self) -> bool:
        return self.is_displayed(self.NO_RESULTS_MSG)

    def get_no_results_message(self) -> str:
        return self.get_text(self.NO_RESULTS_MSG)

    def is_trending_shown(self) -> bool:
        return self.is_displayed(self.TRENDING_SEARCHES)

    def click_first_result(self):
        results = self.get_all_elements(self.RESULT_CARD)
        if results:
            results[0].click()

    def apply_genre_filter(self):
        self.click(self.FILTER_BUTTON)
        self.click(self.GENRE_FILTER)

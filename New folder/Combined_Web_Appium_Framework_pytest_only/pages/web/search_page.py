from selenium.webdriver.common.by import By
from pages.web.base_web_page import BaseWebPage
from utilities.logger import get_logger

log = get_logger(__name__)


class SearchPage(BaseWebPage):
    """Web Search Page — search bar, results list, filters."""

    # ── Locators ──────────────────────────────────────────────────────────────
    SEARCH_INPUT     = (By.CSS_SELECTOR, "input[placeholder='Search...']")
    SEARCH_BUTTON    = (By.XPATH, "//button[@aria-label='Submit search']")
    SEARCH_RESULTS   = (By.CSS_SELECTOR, ".search-results .result-card")
    NO_RESULTS_MSG   = (By.CSS_SELECTOR, ".no-results-text")
    FIRST_RESULT     = (By.CSS_SELECTOR, ".search-results .result-card:first-child")
    RESULT_TITLES    = (By.CSS_SELECTOR, ".result-card .title")

    # ── Actions ───────────────────────────────────────────────────────────────

    def search_for(self, keyword: str):
        log.info(f"Searching for: '{keyword}'")
        self.type_text(self.SEARCH_INPUT, keyword)
        self.click(self.SEARCH_BUTTON)

    def get_results_count(self) -> int:
        results = self.driver.find_elements(*self.SEARCH_RESULTS)
        log.info(f"Search results found: {len(results)}")
        return len(results)

    def get_first_result_title(self) -> str:
        return self.get_text(self.FIRST_RESULT)

    def get_all_result_titles(self) -> list:
        elements = self.driver.find_elements(*self.RESULT_TITLES)
        return [el.text for el in elements]

    def is_no_results_shown(self) -> bool:
        return self.is_displayed(self.NO_RESULTS_MSG)

    def click_first_result(self):
        self.click(self.FIRST_RESULT)
        log.info("Clicked first search result")

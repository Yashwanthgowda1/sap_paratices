"""
pages/search_page.py
--------------------
Locators and actions for the Search results page.
"""

from selenium.webdriver.common.by import By
from tests.hotstar.pages.base_page import BasePage


class SearchPage(BasePage):

    # ── Locators ──────────────────────────────────────────────────────────────

    _SEARCH_HEADING  = (By.CSS_SELECTOR, "[data-testid='search-heading']")
    _RESULT_ITEM     = (By.CSS_SELECTOR, "[data-testid='search-result-item']")
    _NO_RESULT_MSG   = (By.CSS_SELECTOR, "[data-testid='no-results']")
    _RESULT_TITLE    = (By.CSS_SELECTOR, "[data-testid='result-title']")

    # ── Actions ───────────────────────────────────────────────────────────────

    def is_on_search_page(self) -> bool:
        return "search" in self.get_current_url()

    def get_result_count(self) -> int:
        return len(self.driver.find_elements(*self._RESULT_ITEM))

    def get_result_titles(self) -> list:
        elements = self.driver.find_elements(*self._RESULT_TITLE)
        return [e.text for e in elements if e.text]

    def is_no_results_shown(self) -> bool:
        return self.is_element_visible(*self._NO_RESULT_MSG)

    def click_first_result(self):
        results = self.driver.find_elements(*self._RESULT_ITEM)
        assert results, "No search results to click"
        results[0].click()

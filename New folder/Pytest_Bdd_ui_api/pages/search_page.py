from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.support import expected_conditions as EC
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class SearchPage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    SEARCH_INPUT     = (By.CSS_SELECTOR, "input[type='search'], input[placeholder*='Search'], [data-testid='search-input']")
    RESULT_ITEMS     = (By.CSS_SELECTOR, "[data-testid*='search-result'], [class*='search-result'], [class*='SearchResult']")
    RESULT_TITLES    = (By.CSS_SELECTOR, "[data-testid*='result-title'], [class*='result-title'], [class*='cardTitle']")
    NO_RESULTS_MSG   = (By.CSS_SELECTOR, "[class*='no-result'], [data-testid='no-results']")
    FIRST_RESULT_IMG = (By.CSS_SELECTOR, "[data-testid*='search-result']:first-child img, [class*='SearchResult']:first-child img")

    # ── Actions ────────────────────────────────────────────────────────────────
    def enter_search_query(self, keyword: str):
        log.info(f"Entering search keyword: '{keyword}'")
        self.type_text(self.SEARCH_INPUT, keyword)

    def has_results(self) -> bool:
        items = self.find_elements(self.RESULT_ITEMS)
        return len(items) > 0

    def get_first_result_title(self) -> str:
        titles = self.find_elements(self.RESULT_TITLES)
        if titles:
            return titles[0].text.strip()
        items = self.find_elements(self.RESULT_ITEMS)
        if items:
            return items[0].text.strip().split("\n")[0]
        return ""

    def get_all_result_titles(self) -> list:
        titles = self.find_elements(self.RESULT_TITLES)
        if titles:
            return [t.text.strip() for t in titles if t.text.strip()]
        items = self.find_elements(self.RESULT_ITEMS)
        return [i.text.strip().split("\n")[0] for i in items if i.text.strip()]

    def get_result_count(self) -> int:
        return len(self.find_elements(self.RESULT_ITEMS))

    def is_no_results_message_shown(self) -> bool:
        return self.is_displayed(self.NO_RESULTS_MSG, timeout=5)

    def clear_search_input(self):
        element = self.wait.until(EC.visibility_of_element_located(self.SEARCH_INPUT))
        element.clear()
        log.info("Search input cleared")

    def click_first_result(self):
        log.info("Clicking first search result")
        items = self.find_elements(self.RESULT_ITEMS)
        if items:
            self.scroll_to(items[0])
            items[0].click()

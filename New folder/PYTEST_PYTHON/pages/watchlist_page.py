from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class WatchlistPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    WATCHLIST_NAV       = (By.XPATH, "//a[contains(text(),'Watchlist') or contains(text(),'My List')]")
    WATCHLIST_CONTAINER = (By.CSS_SELECTOR, "[class*='watchlist'], [data-testid='watchlist']")
    WATCHLIST_ITEMS     = (By.CSS_SELECTOR, "[class*='watchlist-item'], [data-testid='watchlist-item']")
    WATCHLIST_TITLE     = (By.CSS_SELECTOR, "[class*='item-title'], [data-testid='item-title']")
    EMPTY_WATCHLIST_MSG = (By.XPATH, "//*[contains(text(),'empty') or contains(text(),'Nothing')]")
    REMOVE_BTN          = (By.CSS_SELECTOR, "[aria-label='Remove'], [data-testid='remove-watchlist']")
    BROWSE_BTN          = (By.XPATH, "//button[contains(text(),'Browse')]")
    ITEM_COUNT          = (By.CSS_SELECTOR, "[class*='item-count'], [data-testid='watchlist-count']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def open_watchlist(self):
        log.info("Navigating to Watchlist")
        self.click(self.WATCHLIST_NAV)

    def get_watchlist_items(self) -> list:
        return self.get_all_elements(self.WATCHLIST_ITEMS)

    def get_watchlist_count(self) -> int:
        items = self.get_watchlist_items()
        return len(items)

    def is_empty(self) -> bool:
        return self.is_displayed(self.EMPTY_WATCHLIST_MSG)

    def get_item_titles(self) -> list[str]:
        return [el.text for el in self.get_all_elements(self.WATCHLIST_TITLE)]

    def remove_first_item(self):
        log.info("Removing first watchlist item")
        items = self.get_all_elements(self.REMOVE_BTN)
        if items:
            items[0].click()

    def is_title_in_watchlist(self, title: str) -> bool:
        return title in self.get_item_titles()

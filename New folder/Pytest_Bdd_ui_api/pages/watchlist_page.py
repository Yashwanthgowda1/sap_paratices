from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class WatchlistPage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    WATCHLIST_ITEMS  = (By.CSS_SELECTOR, "[data-testid*='watchlist-item'], [class*='WatchlistCard']")
    EMPTY_MSG        = (By.CSS_SELECTOR, "[class*='empty-watchlist'], [data-testid='empty-watchlist']")

    # ── Actions ────────────────────────────────────────────────────────────────
    def open_watchlist(self):
        self.open(f"{self.driver.current_url.split('/')[0]}//www.hotstar.com/watchlist")

    def get_item_count(self) -> int:
        return len(self.find_elements(self.WATCHLIST_ITEMS))

    def is_empty(self) -> bool:
        return self.is_displayed(self.EMPTY_MSG, timeout=5)

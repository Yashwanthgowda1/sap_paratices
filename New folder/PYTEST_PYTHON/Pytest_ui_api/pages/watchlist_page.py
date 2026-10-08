from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class WatchlistPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    WATCHLIST_ITEMS     = (By.CSS_SELECTOR, "[class*='watchlist-item'], [data-testid*='watchlist-item']")
    EMPTY_WATCHLIST_MSG = (By.CSS_SELECTOR, "[class*='empty-watchlist'], [data-testid='empty-watchlist']")
    REMOVE_BUTTONS      = (By.CSS_SELECTOR, "[aria-label*='Remove'], [data-testid='remove-watchlist']")
    WATCHLIST_NAV_LINK  = (By.XPATH, "//nav//a[contains(text(),'Watchlist') or contains(@href,'watchlist')]")
    WATCHLIST_COUNT     = (By.CSS_SELECTOR, "[data-testid='watchlist-count'], [class*='watchlist-count']")
    LOGIN_PROMPT        = (By.CSS_SELECTOR, "[data-testid='login-prompt'], [class*='login-required']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def go_to_watchlist(self):
        self.click(self.WATCHLIST_NAV_LINK)

    def get_watchlist_items(self) -> list:
        try:
            return self.get_all_elements(self.WATCHLIST_ITEMS)
        except Exception:
            return []

    def is_empty_message_shown(self) -> bool:
        return self.is_displayed(self.EMPTY_WATCHLIST_MSG)

    def remove_first_item(self):
        buttons = self.get_all_elements(self.REMOVE_BUTTONS)
        if buttons:
            buttons[0].click()

    def get_item_count(self) -> int:
        return len(self.get_watchlist_items())

    def is_login_prompt_shown(self) -> bool:
        return self.is_displayed(self.LOGIN_PROMPT)

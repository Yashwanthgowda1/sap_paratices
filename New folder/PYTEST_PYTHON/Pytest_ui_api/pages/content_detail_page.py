from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ContentDetailPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    CONTENT_TITLE        = (By.CSS_SELECTOR, "[class*='content-title'], h1, [data-testid='content-title']")
    PLAY_BUTTON          = (By.CSS_SELECTOR, "[class*='play-btn'], [aria-label='Play'], [data-testid='play-btn']")
    SUBSCRIBE_CTA        = (By.XPATH, "//button[contains(text(),'Subscribe') or contains(text(),'Watch Now')]")
    WATCHLIST_BUTTON     = (By.CSS_SELECTOR, "[aria-label*='watchlist'], [data-testid='watchlist-btn']")
    DESCRIPTION          = (By.CSS_SELECTOR, "[class*='description'], [data-testid='synopsis']")
    GENRE_TAG            = (By.CSS_SELECTOR, "[class*='genre'], [data-testid='genre']")
    RATING               = (By.CSS_SELECTOR, "[class*='rating'], [data-testid='rating']")
    RELATED_CONTENT      = (By.CSS_SELECTOR, "[class*='related'], [data-testid='related-content']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def get_title(self) -> str:
        return self.get_text(self.CONTENT_TITLE)

    def click_play(self):
        self.click(self.PLAY_BUTTON)

    def is_play_button_visible(self) -> bool:
        return self.is_displayed(self.PLAY_BUTTON)

    def is_subscribe_cta_visible(self) -> bool:
        return self.is_displayed(self.SUBSCRIBE_CTA)

    def add_to_watchlist(self):
        self.click(self.WATCHLIST_BUTTON)

    def is_watchlist_button_visible(self) -> bool:
        return self.is_displayed(self.WATCHLIST_BUTTON)

from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ContentDetailPage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    PLAY_BUTTON       = (By.CSS_SELECTOR, "[data-testid='play-btn'], [class*='play-button'], [aria-label='Play']")
    SUBSCRIBE_CTA     = (By.CSS_SELECTOR, "[data-testid='subscribe-btn'], [class*='subscribe'], [class*='paywall']")
    PAYWALL_MESSAGE   = (By.CSS_SELECTOR, "[class*='paywall-msg'], [class*='SubscribeModal'], [data-testid='paywall-text']")
    WATCHLIST_BTN     = (By.CSS_SELECTOR, "[data-testid='watchlist-btn'], [aria-label*='watchlist'], [class*='watchlist-btn']")
    WATCHLIST_ADDED   = (By.CSS_SELECTOR, "[data-testid='watchlist-btn'][class*='added'], [aria-label*='Remove from watchlist']")
    CONTENT_TITLE     = (By.CSS_SELECTOR, "[data-testid='content-title'], [class*='content-title'], h1")
    CONTENT_CONTAINER = (By.CSS_SELECTOR, "[data-testid='content-detail'], [class*='ContentDetail'], main")

    # ── Actions ────────────────────────────────────────────────────────────────
    def is_loaded(self) -> bool:
        return self.is_displayed(self.CONTENT_CONTAINER, timeout=15)

    def click_play_button(self):
        log.info("Clicking Play button")
        self.click(self.PLAY_BUTTON)

    def is_subscribe_cta_visible(self) -> bool:
        return self.is_displayed(self.SUBSCRIBE_CTA, timeout=5)

    def get_paywall_message(self) -> str:
        if self.is_displayed(self.PAYWALL_MESSAGE, timeout=5):
            return self.get_text(self.PAYWALL_MESSAGE)
        if self.is_displayed(self.SUBSCRIBE_CTA, timeout=3):
            return self.get_text(self.SUBSCRIBE_CTA)
        return ""

    def click_watchlist_button(self):
        log.info("Clicking watchlist button")
        self.click(self.WATCHLIST_BTN)

    def is_watchlist_added(self) -> bool:
        return self.is_displayed(self.WATCHLIST_ADDED, timeout=5)

    def get_content_title(self) -> str:
        return self.get_text(self.CONTENT_TITLE)

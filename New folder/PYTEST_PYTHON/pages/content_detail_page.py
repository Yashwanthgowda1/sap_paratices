from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ContentDetailPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    CONTENT_TITLE       = (By.CSS_SELECTOR, "[class*='title'], h1, [data-testid='content-title']")
    CONTENT_DESCRIPTION = (By.CSS_SELECTOR, "[class*='description'], [class*='synopsis'], [data-testid='synopsis']")
    PLAY_BUTTON         = (By.CSS_SELECTOR, "button[aria-label*='Play'], [data-testid='play-btn']")
    WATCHLIST_BTN       = (By.CSS_SELECTOR, "[aria-label*='Watchlist'], [data-testid='watchlist-btn']")
    SHARE_BTN           = (By.CSS_SELECTOR, "[aria-label='Share'], [data-testid='share-btn']")
    RATING              = (By.CSS_SELECTOR, "[class*='rating'], [data-testid='rating']")
    GENRE_TAG           = (By.CSS_SELECTOR, "[class*='genre'], [data-testid='genre']")
    LANGUAGE_TAG        = (By.CSS_SELECTOR, "[class*='language'], [data-testid='language']")
    DURATION            = (By.CSS_SELECTOR, "[class*='duration'], [data-testid='duration']")
    RELEASE_YEAR        = (By.CSS_SELECTOR, "[class*='year'], [data-testid='year']")
    CAST_SECTION        = (By.CSS_SELECTOR, "[class*='cast'], [data-testid='cast']")
    RELATED_CONTENT     = (By.CSS_SELECTOR, "[class*='related'], [data-testid='related']")
    SUBSCRIBE_TO_WATCH  = (By.XPATH, "//button[contains(text(),'Subscribe') or contains(text(),'Upgrade')]")
    EPISODES_TAB        = (By.XPATH, "//button[contains(text(),'Episodes')]")
    EPISODE_CARD        = (By.CSS_SELECTOR, "[class*='episode-card'], [data-testid='episode']")
    TRAILER_BTN         = (By.XPATH, "//button[contains(text(),'Trailer') or contains(text(),'Watch Trailer')]")
    AGE_RATING          = (By.CSS_SELECTOR, "[class*='age-rating'], [data-testid='age-rating']")
    CONTENT_THUMBNAIL   = (By.CSS_SELECTOR, "[class*='thumbnail'], [class*='poster'] img")

    # ── Actions ───────────────────────────────────────────────────────────────
    def get_title(self) -> str:
        return self.get_text(self.CONTENT_TITLE)

    def get_description(self) -> str:
        return self.get_text(self.CONTENT_DESCRIPTION)

    def click_play(self):
        log.info("Clicking Play button on content detail page")
        self.click(self.PLAY_BUTTON)

    def click_watchlist(self):
        log.info("Toggling watchlist")
        self.click(self.WATCHLIST_BTN)

    def get_watchlist_btn_text(self) -> str:
        return self.get_text(self.WATCHLIST_BTN)

    def is_premium_content(self) -> bool:
        return self.is_displayed(self.SUBSCRIBE_TO_WATCH)

    def click_episodes_tab(self):
        self.click(self.EPISODES_TAB)

    def get_episodes(self) -> list:
        return self.get_all_elements(self.EPISODE_CARD)

    def click_trailer(self):
        self.click(self.TRAILER_BTN)

    def get_genre(self) -> str:
        return self.get_text(self.GENRE_TAG)

    def get_rating(self) -> str:
        return self.get_text(self.RATING)

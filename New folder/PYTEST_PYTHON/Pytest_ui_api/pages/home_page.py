from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class HomePage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    LOGO             = (By.CSS_SELECTOR, "[class*='logo'], [alt*='Hotstar'], [alt*='JioCinema']")
    HERO_BANNER      = (By.CSS_SELECTOR, "[class*='hero'], [class*='banner'], [data-testid='hero-banner']")
    HERO_PLAY_BUTTON = (By.CSS_SELECTOR, "[class*='play-btn'], [aria-label*='Play'], [data-testid='play-button']")
    CONTENT_TRAY     = (By.CSS_SELECTOR, "[class*='tray'], [class*='row'], [data-testid*='tray']")
    TRAY_TITLE       = (By.CSS_SELECTOR, "[class*='tray-title'], [class*='row-title'], h2")
    NAV_MOVIES       = (By.XPATH, "//nav//a[contains(text(),'Movies') or contains(@href,'movies')]")
    NAV_SPORTS       = (By.XPATH, "//nav//a[contains(text(),'Sports') or contains(@href,'sports')]")
    NAV_TV_SHOWS     = (By.XPATH, "//nav//a[contains(text(),'TV Shows') or contains(@href,'tv')]")
    SEARCH_ICON      = (By.CSS_SELECTOR, "[data-testid='search-icon'], [aria-label='Search'], [class*='search']")
    SUBSCRIBE_BUTTON = (By.XPATH, "//button[contains(text(),'Subscribe') or contains(text(),'Plans')]")
    CONTINUE_WATCHING = (By.CSS_SELECTOR, "[data-testid='continue-watching'], [class*='continue-watching']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def is_home_page_loaded(self) -> bool:
        return self.is_displayed(self.LOGO) and self.is_displayed(self.HERO_BANNER)

    def get_content_trays(self) -> list:
        try:
            return self.get_all_elements(self.CONTENT_TRAY)
        except Exception:
            return []

    def click_movies_nav(self):
        self.click(self.NAV_MOVIES)

    def click_sports_nav(self):
        self.click(self.NAV_SPORTS)

    def click_search(self):
        self.click(self.SEARCH_ICON)

    def click_hero_play(self):
        self.click(self.HERO_PLAY_BUTTON)

    def is_continue_watching_visible(self) -> bool:
        return self.is_displayed(self.CONTINUE_WATCHING)

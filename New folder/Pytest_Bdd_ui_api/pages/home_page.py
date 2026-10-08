from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class HomePage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    LOGO             = (By.CSS_SELECTOR, "[class*='logo'], [aria-label*='Hotstar'], [data-testid='logo']")
    SEARCH_ICON      = (By.CSS_SELECTOR, "[data-testid='search-icon'], [aria-label='Search'], [class*='search-icon']")
    LOGIN_BTN        = (By.XPATH, "//button[contains(text(),'Log in') or contains(text(),'Sign In')]")
    USER_AVATAR      = (By.CSS_SELECTOR, "[data-testid='user-avatar'], [class*='user-profile'], [class*='avatar']")
    NAV_MOVIES       = (By.XPATH, "//nav//a[contains(text(),'Movies')]")
    NAV_SPORTS       = (By.XPATH, "//nav//a[contains(text(),'Sports')]")
    NAV_SHOWS        = (By.XPATH, "//nav//a[contains(text(),'Shows') or contains(text(),'Series')]")
    HERO_BANNER      = (By.CSS_SELECTOR, "[data-testid='hero-banner'], [class*='hero'], [class*='HeroBanner']")
    CONTENT_TRAY     = (By.CSS_SELECTOR, "[class*='tray'], [class*='Tray'], [data-testid*='tray']")

    # ── Actions ────────────────────────────────────────────────────────────────
    def click_search_icon(self):
        log.info("Clicking search icon")
        self.click(self.SEARCH_ICON)

    def click_login_button(self):
        log.info("Clicking login button in nav")
        self.click(self.LOGIN_BTN)

    def is_user_avatar_visible(self) -> bool:
        return self.is_displayed(self.USER_AVATAR, timeout=10)

    def is_login_button_visible(self) -> bool:
        return self.is_displayed(self.LOGIN_BTN, timeout=5)

    def is_logo_visible(self) -> bool:
        return self.is_displayed(self.LOGO)

    def is_hero_banner_visible(self) -> bool:
        return self.is_displayed(self.HERO_BANNER)

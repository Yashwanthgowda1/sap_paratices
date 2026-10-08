from selenium.webdriver.common.by import By
from pages.web.base_web_page import BaseWebPage
from utilities.logger import get_logger

log = get_logger(__name__)


class HomePage(BaseWebPage):
    """Web Home Page — elements and actions after successful login."""

    # ── Locators ──────────────────────────────────────────────────────────────
    WELCOME_MESSAGE  = (By.CSS_SELECTOR, ".welcome-text")
    USER_AVATAR      = (By.ID, "user-avatar")
    SEARCH_ICON      = (By.XPATH, "//button[@aria-label='Search']")
    NAV_HOME         = (By.CSS_SELECTOR, "nav a[href='/home']")
    NAV_MOVIES       = (By.CSS_SELECTOR, "nav a[href='/movies']")
    NAV_SERIES       = (By.CSS_SELECTOR, "nav a[href='/series']")
    LOGOUT_OPTION    = (By.ID, "logout-btn")
    FEATURED_BANNER  = (By.CSS_SELECTOR, ".hero-banner")

    # ── Actions ───────────────────────────────────────────────────────────────

    def is_home_page_loaded(self) -> bool:
        return self.is_displayed(self.FEATURED_BANNER)

    def get_welcome_text(self) -> str:
        return self.get_text(self.WELCOME_MESSAGE)

    def click_search_icon(self):
        self.click(self.SEARCH_ICON)
        log.info("Search icon clicked from home page")

    def navigate_to_movies(self):
        self.click(self.NAV_MOVIES)
        log.info("Navigated to Movies section")

    def navigate_to_series(self):
        self.click(self.NAV_SERIES)

    def logout(self):
        self.click(self.USER_AVATAR)
        self.click(self.LOGOUT_OPTION)
        log.info("User logged out")

    def is_user_logged_in(self) -> bool:
        return self.is_displayed(self.USER_AVATAR)

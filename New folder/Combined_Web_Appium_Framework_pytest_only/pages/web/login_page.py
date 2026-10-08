from selenium.webdriver.common.by import By
from pages.web.base_web_page import BaseWebPage
from config.config import WebConfig
from utilities.logger import get_logger

log = get_logger(__name__)


class LoginPage(BaseWebPage):
    """
    Web Login Page — locators + actions for login screen.
    Locators defined as class-level tuples (By.strategy, "value").
    """

    # ── Locators ──────────────────────────────────────────────────────────────
    EMAIL_INPUT    = (By.ID,   "email")
    PASSWORD_INPUT = (By.ID,   "password")
    LOGIN_BUTTON   = (By.XPATH, "//button[@type='submit']")
    ERROR_MESSAGE  = (By.CSS_SELECTOR, ".error-message")
    FORGOT_PASSWORD_LINK = (By.LINK_TEXT, "Forgot Password?")

    # ── Actions ───────────────────────────────────────────────────────────────

    def open_login_page(self):
        self.open(f"{WebConfig.BASE_URL}/login")
        log.info("Login page opened")

    def enter_email(self, email: str):
        self.type_text(self.EMAIL_INPUT, email)

    def enter_password(self, password: str):
        self.type_text(self.PASSWORD_INPUT, password)

    def click_login(self):
        self.click(self.LOGIN_BUTTON)
        log.info("Login button clicked")

    def login(self, email: str, password: str):
        """Full login flow — single method for step definitions."""
        self.enter_email(email)
        self.enter_password(password)
        self.click_login()

    def get_error_message(self) -> str:
        return self.get_text(self.ERROR_MESSAGE)

    def is_error_displayed(self) -> bool:
        return self.is_displayed(self.ERROR_MESSAGE)

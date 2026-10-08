from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class LoginPage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    LOGIN_BUTTON_NAV = (By.XPATH, "//button[contains(text(),'Log in') or contains(text(),'Sign In')]")
    EMAIL_FIELD      = (By.CSS_SELECTOR, "input[type='email'], input[name='email']")
    PASSWORD_FIELD   = (By.CSS_SELECTOR, "input[type='password'], input[name='password']")
    SUBMIT_BUTTON    = (By.XPATH, "//button[@type='submit']")
    CONTINUE_BUTTON  = (By.XPATH, "//button[contains(text(),'Continue')]")
    ERROR_MESSAGE    = (By.CSS_SELECTOR, "[class*='error'], [class*='Error'], [data-testid='error-msg']")
    USER_AVATAR      = (By.CSS_SELECTOR, "[data-testid='user-avatar'], [class*='user-profile'], [class*='avatar']")

    # ── Actions ────────────────────────────────────────────────────────────────
    def open_login_page(self):
        self.open()
        log.info("Opening login modal")
        self.click(self.LOGIN_BUTTON_NAV)

    def enter_email(self, email: str):
        self.type_text(self.EMAIL_FIELD, email)

    def click_continue(self):
        self.click(self.CONTINUE_BUTTON)

    def enter_password(self, password: str):
        self.type_text(self.PASSWORD_FIELD, password)

    def click_submit(self):
        self.click(self.SUBMIT_BUTTON)

    def login_with_email(self, email: str, password: str):
        log.info(f"Logging in with: {email}")
        self.enter_email(email)
        self.click_continue()
        self.enter_password(password)
        self.click_submit()

    def is_logged_in(self) -> bool:
        return self.is_displayed(self.USER_AVATAR, timeout=10)

    def is_error_visible(self) -> bool:
        return self.is_displayed(self.ERROR_MESSAGE, timeout=5)

    def get_error_message(self) -> str:
        return self.get_text(self.ERROR_MESSAGE)

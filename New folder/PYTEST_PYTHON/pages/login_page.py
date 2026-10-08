from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class LoginPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    LOGIN_BUTTON_NAV    = (By.XPATH, "//button[contains(text(),'Log in') or contains(text(),'Sign In')]")
    EMAIL_FIELD         = (By.CSS_SELECTOR, "input[type='email'], input[name='email']")
    PASSWORD_FIELD      = (By.CSS_SELECTOR, "input[type='password'], input[name='password']")
    SUBMIT_BUTTON       = (By.XPATH, "//button[@type='submit']")
    CONTINUE_BUTTON     = (By.XPATH, "//button[contains(text(),'Continue')]")
    ERROR_MESSAGE       = (By.CSS_SELECTOR, "[class*='error'], [class*='Error'], [data-testid='error-msg']")
    FORGOT_PASSWORD     = (By.XPATH, "//a[contains(text(),'Forgot')]")
    PHONE_TAB           = (By.XPATH, "//button[contains(text(),'Mobile')]")
    PHONE_FIELD         = (By.CSS_SELECTOR, "input[type='tel'], input[name='mobile']")
    OTP_FIELD           = (By.CSS_SELECTOR, "input[name='otp'], input[placeholder*='OTP']")
    SIGNUP_LINK         = (By.XPATH, "//a[contains(text(),'Sign up') or contains(text(),'Register')]")
    CLOSE_MODAL         = (By.CSS_SELECTOR, "[aria-label='Close'], [class*='close-btn']")
    USER_AVATAR         = (By.CSS_SELECTOR, "[data-testid='user-avatar'], [class*='user-profile']")
    GOOGLE_SSO_BTN      = (By.XPATH, "//button[contains(@aria-label,'Google')]")

    # ── Actions ───────────────────────────────────────────────────────────────
    def open_login_page(self):
        self.open()
        log.info("Opening login modal")
        self.click(self.LOGIN_BUTTON_NAV)

    def login_with_email(self, email: str, password: str):
        log.info(f"Logging in with email: {email}")
        self.type_text(self.EMAIL_FIELD, email)
        self.click(self.CONTINUE_BUTTON)
        self.type_text(self.PASSWORD_FIELD, password)
        self.click(self.SUBMIT_BUTTON)

    def login_with_phone_otp(self, phone: str, otp: str):
        log.info(f"Logging in with phone: {phone}")
        self.click(self.PHONE_TAB)
        self.type_text(self.PHONE_FIELD, phone)
        self.click(self.CONTINUE_BUTTON)
        self.type_text(self.OTP_FIELD, otp)
        self.click(self.SUBMIT_BUTTON)

    def get_error_message(self) -> str:
        return self.get_text(self.ERROR_MESSAGE)

    def is_logged_in(self) -> bool:
        return self.is_displayed(self.USER_AVATAR)

    def click_forgot_password(self):
        self.click(self.FORGOT_PASSWORD)

    def click_signup(self):
        self.click(self.SIGNUP_LINK)

    def close_login_modal(self):
        self.click(self.CLOSE_MODAL)

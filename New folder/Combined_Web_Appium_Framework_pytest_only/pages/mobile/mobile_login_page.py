from appium.webdriver.common.appiumby import AppiumBy
from pages.mobile.base_mobile_page import BaseMobilePage
from utilities.logger import get_logger

log = get_logger(__name__)


class MobileLoginPage(BaseMobilePage):
    """
    Mobile Login Screen.
    Locators use resource-id (By.ID) and accessibility-id — most reliable on Android.
    """

    # ── Locators ──────────────────────────────────────────────────────────────
    USERNAME_INPUT  = (AppiumBy.ID, "com.myapp.android:id/et_username")
    PASSWORD_INPUT  = (AppiumBy.ID, "com.myapp.android:id/et_password")
    LOGIN_BUTTON    = (AppiumBy.ID, "com.myapp.android:id/btn_login")
    ERROR_TOAST     = (AppiumBy.ID, "com.myapp.android:id/tv_error")
    FORGOT_PASSWORD = (AppiumBy.ACCESSIBILITY_ID, "Forgot Password")

    # ── Actions ───────────────────────────────────────────────────────────────

    def enter_username(self, username: str):
        self.type_text(self.USERNAME_INPUT, username)
        self.hide_keyboard()

    def enter_password(self, password: str):
        self.type_text(self.PASSWORD_INPUT, password)
        self.hide_keyboard()

    def tap_login(self):
        self.click(self.LOGIN_BUTTON)
        log.info("[MOBILE] Login button tapped")

    def login(self, username: str, password: str):
        """Full login flow."""
        self.enter_username(username)
        self.enter_password(password)
        self.tap_login()

    def get_error_message(self) -> str:
        return self.get_text(self.ERROR_TOAST)

    def is_error_displayed(self) -> bool:
        return self.is_displayed(self.ERROR_TOAST)

from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ProfilePage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    PROFILE_AVATAR      = (By.CSS_SELECTOR, "[data-testid='user-avatar'], [class*='avatar']")
    PROFILE_DROPDOWN    = (By.CSS_SELECTOR, "[data-testid='profile-menu'], [class*='profile-dropdown']")
    PROFILE_NAME        = (By.CSS_SELECTOR, "[data-testid='profile-name'], [class*='username']")
    ACCOUNT_SETTINGS    = (By.XPATH, "//a[contains(text(),'Account') or contains(text(),'Settings')]")
    MY_SUBSCRIPTION     = (By.XPATH, "//a[contains(text(),'Subscription') or contains(text(),'Plans')]")
    LOGOUT_BTN          = (By.XPATH, "//button[contains(text(),'Logout') or contains(text(),'Sign out')]")
    EDIT_PROFILE_BTN    = (By.CSS_SELECTOR, "[data-testid='edit-profile'], [aria-label='Edit profile']")
    NAME_FIELD          = (By.CSS_SELECTOR, "input[name='name'], input[placeholder*='Name']")
    SAVE_BTN            = (By.XPATH, "//button[contains(text(),'Save')]")
    LANGUAGE_PREFERENCE = (By.CSS_SELECTOR, "[data-testid='language-pref']")
    PARENTAL_CONTROL    = (By.XPATH, "//a[contains(text(),'Parental')]")
    NOTIFICATION_PREF   = (By.CSS_SELECTOR, "[data-testid='notification-pref']")
    DELETE_ACCOUNT      = (By.XPATH, "//button[contains(text(),'Delete account')]")
    PROFILE_PICTURE_BTN = (By.CSS_SELECTOR, "[data-testid='change-photo']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def open_profile_menu(self):
        log.info("Opening profile dropdown")
        self.click(self.PROFILE_AVATAR)

    def go_to_account_settings(self):
        self.open_profile_menu()
        self.click(self.ACCOUNT_SETTINGS)

    def logout(self):
        log.info("Logging out")
        self.open_profile_menu()
        self.click(self.LOGOUT_BTN)

    def update_display_name(self, new_name: str):
        log.info(f"Updating display name to: {new_name}")
        self.click(self.EDIT_PROFILE_BTN)
        self.type_text(self.NAME_FIELD, new_name)
        self.click(self.SAVE_BTN)

    def get_profile_name(self) -> str:
        return self.get_text(self.PROFILE_NAME)

    def go_to_subscription(self):
        self.open_profile_menu()
        self.click(self.MY_SUBSCRIPTION)

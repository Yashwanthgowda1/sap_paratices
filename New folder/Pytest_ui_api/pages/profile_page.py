from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ProfilePage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    PROFILE_AVATAR       = (By.CSS_SELECTOR, "[data-testid='user-avatar'], [class*='user-profile']")
    PROFILE_DROPDOWN     = (By.CSS_SELECTOR, "[class*='profile-dropdown'], [data-testid='profile-menu']")
    PROFILE_NAME         = (By.CSS_SELECTOR, "[data-testid='profile-name'], [class*='user-name']")
    ACCOUNT_SETTINGS_LINK = (By.XPATH, "//a[contains(text(),'Account') or contains(text(),'Settings')]")
    MY_SUBSCRIPTION_LINK = (By.XPATH, "//a[contains(text(),'My Subscription') or contains(text(),'Plans')]")
    LOGOUT_BUTTON        = (By.XPATH, "//button[contains(text(),'Sign Out') or contains(text(),'Logout')]")
    DISPLAY_NAME_FIELD   = (By.CSS_SELECTOR, "input[name='displayName'], input[placeholder*='Name']")
    SAVE_BUTTON          = (By.XPATH, "//button[contains(text(),'Save') or contains(text(),'Update')]")

    # ── Actions ───────────────────────────────────────────────────────────────
    def open_profile_menu(self):
        self.click(self.PROFILE_AVATAR)

    def get_profile_name(self) -> str:
        return self.get_text(self.PROFILE_NAME)

    def go_to_account_settings(self):
        self.open_profile_menu()
        self.click(self.ACCOUNT_SETTINGS_LINK)

    def go_to_my_subscription(self):
        self.open_profile_menu()
        self.click(self.MY_SUBSCRIPTION_LINK)

    def logout(self):
        self.open_profile_menu()
        self.click(self.LOGOUT_BUTTON)

    def update_display_name(self, name: str):
        self.type_text(self.DISPLAY_NAME_FIELD, name)
        self.click(self.SAVE_BUTTON)

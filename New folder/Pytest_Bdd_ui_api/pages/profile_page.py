from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ProfilePage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    AVATAR           = (By.CSS_SELECTOR, "[data-testid='user-avatar'], [class*='user-profile'], [class*='avatar']")
    LOGOUT_OPTION    = (By.XPATH, "//button[contains(text(),'Sign out') or contains(text(),'Log out') or contains(text(),'Logout')]")
    SETTINGS_LINK    = (By.XPATH, "//a[contains(text(),'Account') or contains(text(),'Settings')]")
    DROPDOWN_MENU    = (By.CSS_SELECTOR, "[class*='dropdown-menu'], [class*='ProfileDropdown'], [data-testid='profile-menu']")

    # ── Actions ────────────────────────────────────────────────────────────────
    def click_avatar(self):
        log.info("Clicking user avatar to open profile dropdown")
        self.click(self.AVATAR)

    def click_logout(self):
        log.info("Clicking logout option")
        self.click(self.LOGOUT_OPTION)

    def is_dropdown_visible(self) -> bool:
        return self.is_displayed(self.DROPDOWN_MENU, timeout=5)

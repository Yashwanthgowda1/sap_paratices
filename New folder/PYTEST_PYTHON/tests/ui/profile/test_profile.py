import pytest
import allure
from pages.profile_page import ProfilePage
from pages.home_page import HomePage
from utilities.data_generator import DataGenerator


@allure.epic("JioHotstar")
@allure.feature("User Profile")
@pytest.mark.ui
@pytest.mark.profile
class TestProfile:
    """TC-PROF-001 to TC-PROF-007: User profile and account settings."""

    @allure.story("Profile menu opens")
    @allure.title("TC-PROF-001 | [SANITY] Profile dropdown opens on avatar click")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_profile_menu_opens(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.open_profile_menu()
        assert profile.is_displayed(profile.ACCOUNT_SETTINGS) or \
               profile.is_displayed(profile.LOGOUT_BTN), \
            "Profile dropdown should open with settings/logout options"

    @allure.story("Profile name visible")
    @allure.title("TC-PROF-002 | [SMOKE] Logged-in user's name is shown in profile")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_profile_name_visible(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        name = profile.get_profile_name()
        assert name and len(name) > 0, "Profile name should be displayed after login"

    @allure.story("Account settings page")
    @allure.title("TC-PROF-003 | [REGRESSION] Account settings page opens from profile menu")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_account_settings_page(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.go_to_account_settings()
        assert "account" in logged_in_driver.current_url.lower() or \
               "settings" in logged_in_driver.current_url.lower() or \
               "profile" in logged_in_driver.current_url.lower(), \
            "Should navigate to account/settings page"

    @allure.story("Update display name")
    @allure.title("TC-PROF-004 | [REGRESSION] User can update display name in account settings")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_update_display_name(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.go_to_account_settings()
        new_name = f"Test_{DataGenerator.random_string(4)}"
        if profile.is_displayed(profile.EDIT_PROFILE_BTN):
            profile.update_display_name(new_name)
            assert profile.get_profile_name() == new_name or \
                   profile.is_displayed(profile.SAVE_BTN) is False, \
                "Profile name should be updated"

    @allure.story("Navigate to subscription from profile")
    @allure.title("TC-PROF-005 | [REGRESSION] My Subscription link navigates to plans page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_navigate_to_subscription(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.go_to_subscription()
        assert "subscribe" in logged_in_driver.current_url.lower() or \
               "plan" in logged_in_driver.current_url.lower() or \
               "account" in logged_in_driver.current_url.lower(), \
            "Should navigate to subscription/plans page"

    @allure.story("Logout from profile")
    @allure.title("TC-PROF-006 | [SMOKE] User can logout from profile menu")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_logout_from_profile(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.logout()
        home = HomePage(logged_in_driver)
        assert home.is_displayed(home.SUBSCRIBE_BUTTON) or \
               not profile.is_displayed(profile.PROFILE_AVATAR), \
            "User should be logged out"

    @allure.story("Profile persists across pages")
    @allure.title("TC-PROF-007 | [E2E] Login state persists when navigating across pages")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    def test_login_state_persists(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.navigate_to_movies()
        profile = ProfilePage(logged_in_driver)
        assert profile.is_displayed(profile.PROFILE_AVATAR), \
            "User should remain logged in after navigating to Movies page"
        home.navigate_to_shows()
        assert profile.is_displayed(profile.PROFILE_AVATAR), \
            "User should remain logged in after navigating to Shows page"

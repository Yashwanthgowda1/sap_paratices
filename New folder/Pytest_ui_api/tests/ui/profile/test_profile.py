import pytest
import allure
from pages.login_page import LoginPage
from pages.profile_page import ProfilePage
from pages.subscription_page import SubscriptionPage
from config.config import Config
from test_data import TestData
from utilities.data_generator import DataGenerator


@allure.epic("JioHotstar")
@allure.feature("User Profile - UI")
@pytest.mark.ui
@pytest.mark.profile
class TestProfile:
    """TC-PROF-001 to TC-PROF-007: User profile UI tests."""

    @allure.story("Profile dropdown opens")
    @allure.title("TC-PROF-001 | [SANITY] Profile dropdown opens when clicking the avatar")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_PROF_001
    def test_profile_dropdown_opens(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.open_profile_menu()
        assert profile.is_displayed(profile.PROFILE_DROPDOWN), "Profile dropdown should open on avatar click"

    @allure.story("Profile name visible")
    @allure.title("TC-PROF-002 | [SMOKE] Profile name is visible after login")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_PROF_002
    def test_profile_name_visible_after_login(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.open_profile_menu()
        name = profile.get_profile_name()
        assert name, "Profile name should be visible after login"

    @allure.story("Account settings page")
    @allure.title("TC-PROF-003 | [REGRESSION] Account settings page opens from profile menu")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PROF_003
    def test_account_settings_opens(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.go_to_account_settings()
        url = profile.get_current_url().lower()
        assert "account" in url or "settings" in url or "profile" in url, \
            "URL should reflect account settings page"

    @allure.story("Update display name")
    @allure.title("TC-PROF-004 | [REGRESSION] User can update their display name")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PROF_004
    def test_update_display_name(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.go_to_account_settings()
        new_name = f"AutoUser_{DataGenerator.timestamp_suffix()}"
        profile.update_display_name(new_name)

    @allure.story("My Subscription link")
    @allure.title("TC-PROF-005 | [REGRESSION] My Subscription link navigates to plans page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PROF_005
    def test_my_subscription_link(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.go_to_my_subscription()
        url = profile.get_current_url().lower()
        assert "subscription" in url or "plans" in url, "URL should contain subscription or plans"

    @allure.story("Logout from profile menu")
    @allure.title("TC-PROF-006 | [SANITY] User can logout from the profile menu")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_PROF_006
    def test_logout_from_profile_menu(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.logout()
        assert not profile.is_displayed(profile.PROFILE_AVATAR), "Avatar should be gone after logout"

    @allure.story("Login state persists")
    @allure.title("TC-PROF-007 | [REGRESSION] Login state persists when navigating across pages")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_PROF_007
    def test_login_state_persists_across_pages(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        assert profile.is_displayed(profile.PROFILE_AVATAR), "Should be logged in on home page"
        profile.open(f"{Config.BASE_URL}/in/movies")
        assert profile.is_displayed(profile.PROFILE_AVATAR), "Should remain logged in on movies page"
        profile.open(f"{Config.BASE_URL}/in/sports")
        assert profile.is_displayed(profile.PROFILE_AVATAR), "Should remain logged in on sports page"

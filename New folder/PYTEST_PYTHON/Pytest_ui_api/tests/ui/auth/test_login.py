import pytest
import allure
from pages.login_page import LoginPage
from pages.home_page import HomePage
from pages.profile_page import ProfilePage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Authentication - UI")
@pytest.mark.ui
@pytest.mark.auth
class TestLogin:
    """TC-AUTH-001 to TC-AUTH-010: Login / Logout UI scenarios."""

    @allure.story("Login with valid credentials")
    @allure.title("TC-AUTH-001 | [SANITY] Successful login with valid email and password")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_AUTH_001
    def test_login_valid_email_password(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.login_with_email(TestData.VALID_USER["email"], TestData.VALID_USER["password"])
        assert login.is_logged_in(), "User should be logged in after valid credentials"

    @allure.story("Login with invalid credentials")
    @allure.title("TC-AUTH-002 | [SMOKE] Login shows error for wrong password")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.negative
    @pytest.mark.TC_AUTH_002
    def test_login_invalid_password(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.login_with_email(TestData.VALID_USER["email"], TestData.INVALID_USER["password"])
        error = login.get_error_message()
        assert error, "Error message should be shown for invalid password"

    @allure.story("Login with non-existent email")
    @allure.title("TC-AUTH-003 | [SMOKE] Login fails for unregistered email")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.negative
    @pytest.mark.TC_AUTH_003
    def test_login_unregistered_email(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.login_with_email(TestData.INVALID_USER["email"], TestData.INVALID_USER["password"])
        error = login.get_error_message()
        assert error, "Error message should appear for unregistered email"

    @allure.story("Login with empty email")
    @allure.title("TC-AUTH-004 | [REGRESSION] Continue button disabled for empty email field")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.negative
    @pytest.mark.TC_AUTH_004
    def test_login_empty_email(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.type_text(login.EMAIL_FIELD, "")
        assert not login.is_enabled(login.CONTINUE_BUTTON), "Continue should be disabled for empty email"

    @allure.story("Forgot password link")
    @allure.title("TC-AUTH-005 | [REGRESSION] Forgot Password navigates to reset page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_AUTH_005
    def test_forgot_password_link(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.click_forgot_password()
        url = login.get_current_url().lower()
        assert "forgot" in url or "reset" in url, "URL should contain forgot or reset"

    @allure.story("Signup link visibility")
    @allure.title("TC-AUTH-006 | [REGRESSION] Sign Up link is visible on login page")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_AUTH_006
    def test_signup_link_visible(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        assert login.is_displayed(login.SIGNUP_LINK), "Sign up link should be visible"

    @allure.story("Close login modal")
    @allure.title("TC-AUTH-007 | [REGRESSION] Login modal closes when clicking X")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_AUTH_007
    def test_login_modal_close(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.close_login_modal()
        assert not login.is_displayed(login.EMAIL_FIELD), "Login modal should be dismissed"

    @allure.story("Logout")
    @allure.title("TC-AUTH-008 | [SANITY] User can log out successfully")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_AUTH_008
    def test_logout(self, logged_in_driver):
        profile = ProfilePage(logged_in_driver)
        profile.logout()
        home = HomePage(logged_in_driver)
        assert home.is_displayed(home.SUBSCRIBE_BUTTON) or not profile.is_displayed(profile.PROFILE_AVATAR), \
            "User should be logged out"

    @allure.story("Login and home loads")
    @allure.title("TC-AUTH-009 | [E2E] User logs in and home page shows content trays")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.e2e
    @pytest.mark.TC_AUTH_009
    def test_login_and_home_loads(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.login_with_email(TestData.VALID_USER["email"], TestData.VALID_USER["password"])
        home = HomePage(driver)
        assert home.is_home_page_loaded(), "Home page should load after login"
        assert len(home.get_content_trays()) > 0, "Home page should have content trays"

    @allure.story("Invalid email format")
    @allure.title("TC-AUTH-010 | [NEGATIVE] Invalid email format shows validation error")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_AUTH_010
    def test_login_invalid_email_format(self, driver):
        login = LoginPage(driver)
        login.open_login_page()
        login.type_text(login.EMAIL_FIELD, "not-an-email")
        login.click(login.CONTINUE_BUTTON)
        has_error = login.get_error_message() if login.wait.is_element_present(login.ERROR_MESSAGE) else None
        assert has_error or not login.wait.is_element_present(login.PASSWORD_FIELD, timeout=3), \
            "Validation error should appear for invalid email format"

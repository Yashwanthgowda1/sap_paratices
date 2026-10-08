import pytest
import allure
from config.config import WebConfig


@allure.feature("Web Login")
class TestWebLogin:
    """
    Web login test suite.
    Fixtures (login_page, home_page, soft_assert) are injected by conftest.py.
    No BDD — plain pytest class-based test structure.
    """

    @allure.story("Valid login")
    @allure.severity(allure.severity_level.CRITICAL)
    def test_valid_login_navigates_to_home(self, login_page, home_page):
        login_page.open_login_page()
        login_page.login(WebConfig.VALID_EMAIL, WebConfig.VALID_PASSWORD)
        assert home_page.is_user_logged_in(), "User should be logged in after valid credentials"

    @allure.story("Invalid login")
    @allure.severity(allure.severity_level.NORMAL)
    def test_invalid_login_shows_error(self, login_page):
        login_page.open_login_page()
        login_page.login("wrong@test.com", "WrongPass999")
        assert login_page.is_error_displayed(), "Error message should appear for invalid credentials"
        assert "Invalid" in login_page.get_error_message()

    @allure.story("Empty credentials")
    def test_login_with_empty_fields_shows_error(self, login_page):
        login_page.open_login_page()
        login_page.click_login()
        assert login_page.is_error_displayed(), "Error should show when fields are empty"

    @allure.story("Logout")
    def test_logout_redirects_to_login(self, login_page, home_page):
        login_page.open_login_page()
        login_page.login(WebConfig.VALID_EMAIL, WebConfig.VALID_PASSWORD)
        home_page.logout()
        assert "login" in login_page.get_current_url().lower(), \
            "After logout, URL should contain 'login'"

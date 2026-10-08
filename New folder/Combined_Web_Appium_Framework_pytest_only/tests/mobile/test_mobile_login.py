import pytest
import allure
from config.config import MobileConfig


@allure.feature("Mobile Login")
class TestMobileLogin:
    """
    Mobile (Android) login test suite.
    Fixtures (mobile_login_page, mobile_home_page) are injected by conftest.py.
    mobile_driver fixture starts Appium session before each test.
    """

    @allure.story("Valid login on Android")
    @allure.severity(allure.severity_level.CRITICAL)
    def test_valid_login_shows_home_screen(self, mobile_login_page, mobile_home_page):
        mobile_login_page.login(MobileConfig.VALID_USERNAME, MobileConfig.VALID_PASSWORD)
        assert mobile_home_page.is_home_loaded(), \
            "Home screen should be visible after successful login"

    @allure.story("Invalid login on Android")
    def test_invalid_login_shows_error(self, mobile_login_page):
        mobile_login_page.login("wronguser", "wrongpass")
        assert mobile_login_page.is_error_displayed(), \
            "Error message should appear for invalid credentials"

    @allure.story("Empty username on Android")
    def test_empty_username_shows_error(self, mobile_login_page):
        mobile_login_page.enter_password("somepass")
        mobile_login_page.tap_login()
        assert mobile_login_page.is_error_displayed(), \
            "Error should appear when username is empty"

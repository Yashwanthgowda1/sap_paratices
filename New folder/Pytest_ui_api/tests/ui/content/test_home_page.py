import pytest
import allure
from pages.home_page import HomePage
from pages.login_page import LoginPage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Home Page - UI")
@pytest.mark.ui
@pytest.mark.content
class TestHomePage:
    """TC-HOME-001 to TC-HOME-008: Home page and navigation tests."""

    @allure.story("Home page loads")
    @allure.title("TC-HOME-001 | [SANITY] Home page loads with logo and hero banner")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_001
    def test_home_page_loads(self, driver):
        home = HomePage(driver)
        home.open()
        assert home.is_home_page_loaded(), "Logo and hero banner must be visible"

    @allure.story("Navigation items")
    @allure.title("TC-HOME-002 | [SMOKE] All nav items are present on home page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_002
    def test_nav_items_present(self, driver):
        home = HomePage(driver)
        home.open()
        assert home.is_displayed(home.NAV_MOVIES),   "Movies nav should be visible"
        assert home.is_displayed(home.NAV_SPORTS),   "Sports nav should be visible"
        assert home.is_displayed(home.NAV_TV_SHOWS), "TV Shows nav should be visible"

    @allure.story("Hero banner play button")
    @allure.title("TC-HOME-003 | [SMOKE] Hero banner has a Play button")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_003
    def test_hero_banner_play_button(self, driver):
        home = HomePage(driver)
        home.open()
        assert home.is_displayed(home.HERO_PLAY_BUTTON), "Hero banner must have a play button"

    @allure.story("Content trays")
    @allure.title("TC-HOME-004 | [SMOKE] Home page shows multiple content trays")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_004
    def test_multiple_content_trays(self, driver):
        home = HomePage(driver)
        home.open()
        trays = home.get_content_trays()
        assert len(trays) > 1, f"Expected >1 content trays, got {len(trays)}"

    @allure.story("Movies navigation")
    @allure.title("TC-HOME-005 | [REGRESSION] Movies nav navigates to movies catalogue")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_HOME_005
    def test_movies_nav_navigates(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_movies_nav()
        assert "movies" in home.get_current_url().lower(), "URL should contain 'movies'"

    @allure.story("Sports navigation")
    @allure.title("TC-HOME-006 | [REGRESSION] Sports nav navigates to sports section")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_HOME_006
    def test_sports_nav_navigates(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_sports_nav()
        assert "sports" in home.get_current_url().lower(), "URL should contain 'sports'"

    @allure.story("Search icon clickable")
    @allure.title("TC-HOME-007 | [SMOKE] Search icon on home page is clickable")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_007
    def test_search_icon_clickable(self, driver):
        home = HomePage(driver)
        home.open()
        assert home.is_displayed(home.SEARCH_ICON), "Search icon should be visible"
        home.click_search()

    @allure.story("Continue watching for logged-in user")
    @allure.title("TC-HOME-008 | [REGRESSION] Continue Watching tray appears for logged-in user")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_HOME_008
    def test_continue_watching_logged_in(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open()
        assert home.is_continue_watching_visible(), "Continue Watching tray should show for logged-in user"

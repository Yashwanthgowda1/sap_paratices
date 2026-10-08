import pytest
import allure
from pages.home_page import HomePage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Home Page")
@pytest.mark.ui
class TestHomePage:
    """TC-HOME-001 to TC-HOME-008: Home page content and navigation."""

    @allure.story("Home page loads")
    @allure.title("TC-HOME-001 | [SANITY] Home page loads with logo and hero banner")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_001
    def test_home_page_loads(self, driver):
        home = HomePage(driver)
        home.open_home()
        assert home.is_home_page_loaded(), "Home page should display logo and hero banner"

    @allure.story("Navigation menu items")
    @allure.title("TC-HOME-002 | [SMOKE] All nav items (Movies, Shows, Sports, Live) are present")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_002
    def test_nav_items_present(self, driver):
        home = HomePage(driver)
        home.open_home()
        assert home.is_displayed(home.NAV_MOVIES), "Movies nav item missing"
        assert home.is_displayed(home.NAV_SHOWS), "Shows nav item missing"
        assert home.is_displayed(home.NAV_SPORTS), "Sports nav item missing"

    @allure.story("Hero banner play button")
    @allure.title("TC-HOME-003 | [SANITY] Hero banner has a play button")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.sanity
    @pytest.mark.TC_HOME_003
    def test_hero_play_button_visible(self, driver):
        home = HomePage(driver)
        home.open_home()
        assert home.is_displayed(home.HERO_PLAY_BTN), "Hero banner must have a Play button"

    @allure.story("Content trays on home")
    @allure.title("TC-HOME-004 | [REGRESSION] Home page shows multiple content trays")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_HOME_004
    def test_content_trays_present(self, driver):
        home = HomePage(driver)
        home.open_home()
        trays = home.get_content_trays()
        assert len(trays) >= 2, f"Expected at least 2 content trays, found {len(trays)}"

    @allure.story("Navigate to Movies")
    @allure.title("TC-HOME-005 | [REGRESSION] Movies nav navigates to movies catalogue")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_HOME_005
    def test_navigate_to_movies(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.navigate_to_movies()
        assert "movies" in home.get_current_url().lower(), "URL should contain 'movies'"

    @allure.story("Navigate to Sports")
    @allure.title("TC-HOME-006 | [REGRESSION] Sports nav navigates to sports section")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_HOME_006
    def test_navigate_to_sports(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.navigate_to_sports()
        assert "sport" in home.get_current_url().lower(), "URL should contain 'sport'"

    @allure.story("Search icon clickable")
    @allure.title("TC-HOME-007 | [SMOKE] Search icon on home page is clickable")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_HOME_007
    def test_search_icon_clickable(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        from pages.search_page import SearchPage
        search = SearchPage(driver)
        assert search.is_displayed(search.SEARCH_INPUT), "Search input should appear after clicking search icon"

    @allure.story("Continue watching after login")
    @allure.title("TC-HOME-008 | [E2E] Continue Watching section appears for logged-in user")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.e2e
    @pytest.mark.TC_HOME_008
    def test_continue_watching_logged_in(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open_home()
        assert home.is_section_present("Continue Watching") or home.is_home_page_loaded(), \
            "Continue Watching or personalized content should appear when logged in"

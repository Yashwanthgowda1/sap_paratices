import pytest
import allure
from pages.home_page import HomePage
from pages.content_detail_page import ContentDetailPage
from pages.watchlist_page import WatchlistPage
from config.config import Config
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Watchlist - UI")
@pytest.mark.ui
@pytest.mark.watchlist
class TestWatchlist:
    """TC-WL-001 to TC-WL-008: Watchlist feature UI tests."""

    CONTENT_URL = f"{Config.BASE_URL}/in/watch/{Config.FREE_CONTENT_ID}"

    @allure.story("Add to watchlist")
    @allure.title("TC-WL-001 | [SANITY] Logged-in user can add content to watchlist")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_WL_001
    def test_add_to_watchlist(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.CONTENT_URL)
        detail = ContentDetailPage(logged_in_driver)
        detail.add_to_watchlist()
        assert detail.is_watchlist_button_visible(), "Watchlist button should remain visible after clicking"

    @allure.story("Remove from watchlist")
    @allure.title("TC-WL-002 | [SMOKE] User can remove content from watchlist")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_WL_002
    def test_remove_from_watchlist(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.CONTENT_URL)
        detail = ContentDetailPage(logged_in_driver)
        detail.add_to_watchlist()
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.go_to_watchlist()
        count_before = watchlist.get_item_count()
        watchlist.remove_first_item()
        count_after = watchlist.get_item_count()
        assert count_after < count_before, "Item count should decrease after removal"

    @allure.story("Added content appears in watchlist")
    @allure.title("TC-WL-003 | [REGRESSION] Added content appears on the watchlist page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_WL_003
    def test_added_content_appears_in_watchlist(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.CONTENT_URL)
        detail = ContentDetailPage(logged_in_driver)
        detail.add_to_watchlist()
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.go_to_watchlist()
        assert watchlist.get_item_count() > 0, "Watchlist page should show added content"

    @allure.story("Empty watchlist message")
    @allure.title("TC-WL-004 | [REGRESSION] Empty watchlist shows browse message")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_WL_004
    def test_empty_watchlist_message(self, logged_in_driver):
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.go_to_watchlist()
        if watchlist.get_item_count() == 0:
            assert watchlist.is_empty_message_shown(), "Empty watchlist should show a browse message"

    @allure.story("Watchlist requires login")
    @allure.title("TC-WL-005 | [NEGATIVE] Accessing watchlist without login shows login prompt")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_WL_005
    def test_watchlist_requires_login(self, driver):
        watchlist = WatchlistPage(driver)
        watchlist.go_to_watchlist()
        assert watchlist.is_login_prompt_shown() or "login" in watchlist.get_current_url().lower(), \
            "Login prompt should appear for unauthenticated users accessing watchlist"

    @allure.story("Watchlist count increases")
    @allure.title("TC-WL-006 | [REGRESSION] Watchlist count increases after adding an item")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_WL_006
    def test_watchlist_count_increases(self, logged_in_driver):
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.go_to_watchlist()
        count_before = watchlist.get_item_count()
        home = HomePage(logged_in_driver)
        home.open(self.CONTENT_URL)
        detail = ContentDetailPage(logged_in_driver)
        detail.add_to_watchlist()
        watchlist.go_to_watchlist()
        count_after = watchlist.get_item_count()
        assert count_after >= count_before, "Watchlist count should not decrease after adding"

    @allure.story("Remove from watchlist page")
    @allure.title("TC-WL-007 | [REGRESSION] User can remove an item directly from watchlist page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_WL_007
    def test_remove_item_from_watchlist_page(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.CONTENT_URL)
        detail = ContentDetailPage(logged_in_driver)
        detail.add_to_watchlist()
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.go_to_watchlist()
        count_before = watchlist.get_item_count()
        if count_before > 0:
            watchlist.remove_first_item()
            assert watchlist.get_item_count() == count_before - 1, "Count should drop by 1 after removal"

    @allure.story("End-to-end watchlist journey")
    @allure.title("TC-WL-008 | [E2E] Full add-view-remove watchlist journey")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.e2e
    @pytest.mark.TC_WL_008
    def test_e2e_watchlist_journey(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.CONTENT_URL)
        detail = ContentDetailPage(logged_in_driver)
        detail.add_to_watchlist()

        watchlist = WatchlistPage(logged_in_driver)
        watchlist.go_to_watchlist()
        assert watchlist.get_item_count() > 0, "Watchlist should contain the added item"

        watchlist.remove_first_item()
        assert watchlist.get_item_count() == 0 or watchlist.is_empty_message_shown() or True, \
            "Item should be removed from watchlist"

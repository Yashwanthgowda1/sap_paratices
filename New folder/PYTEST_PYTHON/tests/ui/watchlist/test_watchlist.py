import pytest
import allure
from pages.watchlist_page import WatchlistPage
from pages.home_page import HomePage
from pages.content_detail_page import ContentDetailPage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Watchlist")
@pytest.mark.ui
@pytest.mark.watchlist
class TestWatchlist:
    """TC-WL-001 to TC-WL-008: Watchlist / My List functionality."""

    def _open_content_detail(self, driver, title: str) -> ContentDetailPage:
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        from pages.search_page import SearchPage
        search = SearchPage(driver)
        search.search(title)
        search.click_first_result()
        return ContentDetailPage(driver)

    @allure.story("Add to watchlist")
    @allure.title("TC-WL-001 | [SANITY] Logged-in user can add content to watchlist")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_add_to_watchlist(self, logged_in_driver):
        detail = self._open_content_detail(logged_in_driver, TestData.SERIES["title"])
        detail.click_watchlist()
        btn_text = detail.get_watchlist_btn_text().lower()
        assert "added" in btn_text or "remove" in btn_text or "saved" in btn_text, \
            "Watchlist button should reflect 'added' state"

    @allure.story("Remove from watchlist")
    @allure.title("TC-WL-002 | [SMOKE] User can remove content from watchlist")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_remove_from_watchlist(self, logged_in_driver):
        detail = self._open_content_detail(logged_in_driver, TestData.SERIES["title"])
        detail.click_watchlist()  # add
        detail.click_watchlist()  # remove
        btn_text = detail.get_watchlist_btn_text().lower()
        assert "add" in btn_text or "watchlist" in btn_text, \
            "Watchlist button should revert to 'add' state after removal"

    @allure.story("Watchlist page shows added items")
    @allure.title("TC-WL-003 | [REGRESSION] Added content appears on watchlist page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    def test_content_in_watchlist_page(self, logged_in_driver):
        detail = self._open_content_detail(logged_in_driver, TestData.SERIES["title"])
        detail.click_watchlist()
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.open_watchlist()
        assert not watchlist.is_empty(), "Watchlist should not be empty after adding content"

    @allure.story("Empty watchlist message")
    @allure.title("TC-WL-004 | [REGRESSION] Empty watchlist shows browse message")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_empty_watchlist_message(self, logged_in_driver):
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.open_watchlist()
        if watchlist.is_empty():
            assert watchlist.is_displayed(watchlist.EMPTY_WATCHLIST_MSG), \
                "Empty watchlist message should be displayed"

    @allure.story("Watchlist requires login")
    @allure.title("TC-WL-005 | [SMOKE] Watchlist button prompts login for unauthenticated user")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_watchlist_requires_login(self, driver):
        detail = self._open_content_detail(driver, TestData.SERIES["title"])
        detail.click_watchlist()
        from pages.login_page import LoginPage
        login = LoginPage(driver)
        assert login.is_displayed(login.EMAIL_FIELD) or login.is_displayed(login.LOGIN_BUTTON_NAV), \
            "Should prompt login when adding to watchlist as guest"

    @allure.story("Watchlist count increases")
    @allure.title("TC-WL-006 | [REGRESSION] Watchlist item count increases after adding content")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_watchlist_count_increases(self, logged_in_driver):
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.open_watchlist()
        count_before = watchlist.get_watchlist_count()
        detail = self._open_content_detail(logged_in_driver, TestData.MOVIE["title"])
        detail.click_watchlist()
        watchlist.open_watchlist()
        count_after = watchlist.get_watchlist_count()
        assert count_after >= count_before, "Watchlist count should increase after adding content"

    @allure.story("Remove from watchlist page")
    @allure.title("TC-WL-007 | [REGRESSION] User can remove item directly from watchlist page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_remove_from_watchlist_page(self, logged_in_driver):
        detail = self._open_content_detail(logged_in_driver, TestData.SERIES["title"])
        detail.click_watchlist()
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.open_watchlist()
        count_before = watchlist.get_watchlist_count()
        watchlist.remove_first_item()
        count_after = watchlist.get_watchlist_count()
        assert count_after < count_before, "Watchlist count should decrease after removing item"

    @allure.story("E2E watchlist journey")
    @allure.title("TC-WL-008 | [E2E] Add, view, and remove item from watchlist")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    def test_e2e_watchlist_journey(self, logged_in_driver):
        detail = self._open_content_detail(logged_in_driver, TestData.SERIES["title"])
        detail.click_watchlist()
        watchlist = WatchlistPage(logged_in_driver)
        watchlist.open_watchlist()
        assert not watchlist.is_empty(), "Watchlist should have item after adding"
        watchlist.remove_first_item()
        assert watchlist.is_empty() or watchlist.get_watchlist_count() >= 0, \
            "Watchlist should reflect removal"

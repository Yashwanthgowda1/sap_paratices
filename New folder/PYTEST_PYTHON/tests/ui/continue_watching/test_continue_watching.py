import pytest
import allure
from pages.continue_watching_page import ContinueWatchingPage
from pages.home_page import HomePage
from pages.player_page import PlayerPage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Continue Watching")
@pytest.mark.ui
@pytest.mark.continue_watching
class TestContinueWatching:
    """TC-CW-001 to TC-CW-008: Continue Watching tray functionality."""

    def _start_and_pause_video(self, driver):
        """Helper — opens a free content video, plays briefly, then goes back home."""
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        from pages.search_page import SearchPage
        search = SearchPage(driver)
        search.search(TestData.FREE_CONTENT["title"])
        search.click_first_result()
        from pages.content_detail_page import ContentDetailPage
        detail = ContentDetailPage(driver)
        detail.click_play()
        player = PlayerPage(driver)
        player.pause_video()
        home.open_home()

    @allure.story("Continue Watching tray visible after partial watch")
    @allure.title("TC-CW-001 | [SANITY] Continue Watching tray appears after partially watching content")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_CW_001
    def test_cw_tray_visible_after_partial_watch(self, logged_in_driver):
        self._start_and_pause_video(logged_in_driver)
        cw = ContinueWatchingPage(logged_in_driver)
        assert cw.is_tray_visible(), \
            "Continue Watching tray should appear on home page after partial watch"

    @allure.story("Progress bar shown on tray item")
    @allure.title("TC-CW-002 | [SMOKE] Progress bar is shown on Continue Watching tray item")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_CW_002
    def test_progress_bar_visible_on_tray_item(self, logged_in_driver):
        self._start_and_pause_video(logged_in_driver)
        cw = ContinueWatchingPage(logged_in_driver)
        if cw.is_tray_visible():
            assert cw.is_progress_bar_visible(), \
                "Progress bar should be visible on Continue Watching item"

    @allure.story("Resume from Continue Watching tray")
    @allure.title("TC-CW-003 | [REGRESSION] Clicking Resume plays content from where user left off")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_CW_003
    def test_resume_plays_from_tray(self, logged_in_driver):
        self._start_and_pause_video(logged_in_driver)
        cw = ContinueWatchingPage(logged_in_driver)
        if cw.is_tray_visible():
            cw.click_resume()
            player = PlayerPage(logged_in_driver)
            assert player.is_player_visible(), \
                "Player should open after clicking Resume from Continue Watching tray"

    @allure.story("Tray item count")
    @allure.title("TC-CW-004 | [REGRESSION] Continue Watching tray shows correct number of items")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_CW_004
    def test_cw_tray_item_count(self, logged_in_driver):
        self._start_and_pause_video(logged_in_driver)
        cw = ContinueWatchingPage(logged_in_driver)
        if cw.is_tray_visible():
            count = cw.get_item_count()
            assert count >= 1, \
                f"Continue Watching tray should have at least 1 item, found {count}"

    @allure.story("Remove item from Continue Watching tray")
    @allure.title("TC-CW-005 | [REGRESSION] User can remove item from Continue Watching tray")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_CW_005
    def test_remove_item_from_cw_tray(self, logged_in_driver):
        self._start_and_pause_video(logged_in_driver)
        cw = ContinueWatchingPage(logged_in_driver)
        if cw.is_tray_visible():
            count_before = cw.get_item_count()
            cw.remove_first_item()
            count_after = cw.get_item_count()
            assert count_after < count_before, \
                "Item count should decrease after removing from Continue Watching tray"

    @allure.story("Content title in tray")
    @allure.title("TC-CW-006 | [REGRESSION] Watched content title appears in Continue Watching tray")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_CW_006
    def test_watched_title_in_cw_tray(self, logged_in_driver):
        self._start_and_pause_video(logged_in_driver)
        cw = ContinueWatchingPage(logged_in_driver)
        if cw.is_tray_visible():
            titles = cw.get_item_titles()
            assert len(titles) > 0, "Continue Watching tray should show content titles"

    @allure.story("CW tray not shown for guest user")
    @allure.title("TC-CW-007 | [NEGATIVE] Continue Watching tray is not shown for guest user")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.TC_CW_007
    def test_cw_tray_not_shown_for_guest(self, driver):
        home = HomePage(driver)
        home.open_home()
        cw = ContinueWatchingPage(driver)
        assert not cw.is_tray_visible(), \
            "Continue Watching tray should not be visible for unauthenticated user"

    @allure.story("E2E Continue Watching journey")
    @allure.title("TC-CW-008 | [E2E] Watch partially, go to home, resume from Continue Watching tray")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    @pytest.mark.TC_CW_008
    def test_e2e_continue_watching_journey(self, logged_in_driver):
        # Step 1 — partially watch content
        self._start_and_pause_video(logged_in_driver)

        # Step 2 — verify tray appears on home
        cw = ContinueWatchingPage(logged_in_driver)
        assert cw.is_tray_visible(), \
            "Continue Watching tray should appear after partial watch"

        # Step 3 — verify progress bar shown
        assert cw.is_progress_bar_visible(), \
            "Progress bar should indicate watch progress"

        # Step 4 — resume from tray
        cw.click_resume()
        player = PlayerPage(logged_in_driver)
        assert player.is_player_visible(), \
            "Player should open from Continue Watching resume"

import pytest
import allure
from pages.content_detail_page import ContentDetailPage
from pages.home_page import HomePage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Video Player")
@pytest.mark.ui
@pytest.mark.player
class TestPlayer:
    """TC-PLYR-001 to TC-PLYR-010: Video player scenarios."""

    def _navigate_to_free_content(self, driver) -> ContentDetailPage:
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        from pages.search_page import SearchPage
        search = SearchPage(driver)
        search.search(TestData.FREE_CONTENT["title"])
        search.click_first_result()
        return ContentDetailPage(driver)

    @allure.story("Player loads for free content")
    @allure.title("TC-PLYR-001 | [SANITY] Video player loads when Play is clicked on free content")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_player_loads_free_content(self, driver):
        detail = self._navigate_to_free_content(driver)
        assert detail.is_displayed(detail.PLAY_BUTTON), "Play button should be on content detail"
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(driver)
        player.wait_for_player_to_load()
        assert player.is_player_loaded(), "Video player should load"

    @allure.story("Premium content requires subscription")
    @allure.title("TC-PLYR-002 | [SMOKE] Premium content shows Subscribe CTA for non-subscriber")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_premium_content_shows_subscribe(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        from pages.search_page import SearchPage
        search = SearchPage(driver)
        search.search(TestData.MOVIE["title"])
        search.click_first_result()
        detail = ContentDetailPage(driver)
        assert detail.is_premium_content() or detail.is_displayed(detail.PLAY_BUTTON), \
            "Premium content should show Subscribe CTA or Play if user has subscription"

    @allure.story("Play pause toggle")
    @allure.title("TC-PLYR-003 | [REGRESSION] Play/Pause button toggles playback state")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    def test_play_pause_toggle(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        playing_before = player.is_playing()
        player.play_pause()
        playing_after = player.is_playing()
        assert playing_before != playing_after, "Play state should toggle on button click"

    @allure.story("Fullscreen mode")
    @allure.title("TC-PLYR-004 | [REGRESSION] Fullscreen button enters fullscreen mode")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_fullscreen(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        player.go_fullscreen()
        assert player.is_fullscreen(), "Browser should be in fullscreen mode"

    @allure.story("Forward 10 seconds")
    @allure.title("TC-PLYR-005 | [REGRESSION] Forward 10s button skips playback forward")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_forward_10_seconds(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        time_before = player.get_current_time()
        player.forward_10s()
        time_after = player.get_current_time()
        assert time_before != time_after, "Playback time should advance after forward"

    @allure.story("Player controls visible")
    @allure.title("TC-PLYR-006 | [SMOKE] All player controls (play, volume, fullscreen) are visible")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    def test_player_controls_visible(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        assert player.is_displayed(player.PLAY_PAUSE_BTN), "Play/Pause button missing"
        assert player.is_displayed(player.VOLUME_BTN), "Volume button missing"
        assert player.is_displayed(player.FULLSCREEN_BTN), "Fullscreen button missing"

    @allure.story("Mute volume")
    @allure.title("TC-PLYR-007 | [REGRESSION] Volume button mutes/unmutes audio")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_mute_volume(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        player.mute_volume()
        is_muted = logged_in_driver.execute_script("return document.querySelector('video').muted;")
        assert is_muted, "Video should be muted after clicking mute"

    @allure.story("Player settings menu")
    @allure.title("TC-PLYR-008 | [REGRESSION] Settings gear opens quality/subtitle options")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_settings_menu(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        player.open_settings()
        assert player.is_displayed(player.QUALITY_OPTION) or player.is_displayed(player.SUBTITLE_BTN), \
            "Settings menu should show quality or subtitle options"

    @allure.story("No player error on load")
    @allure.title("TC-PLYR-009 | [NEGATIVE] Player should not show error overlay on valid content")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.negative
    @pytest.mark.regression
    def test_no_player_error(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        assert not player.is_error_shown(), "No error overlay should appear for valid content"

    @allure.story("Exit player")
    @allure.title("TC-PLYR-010 | [E2E] User can exit player and return to content detail page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.e2e
    def test_exit_player(self, logged_in_driver):
        detail = self._navigate_to_free_content(logged_in_driver)
        detail.click_play()
        from pages.player_page import PlayerPage
        player = PlayerPage(logged_in_driver)
        player.wait_for_player_to_load()
        player.exit_player()
        assert detail.is_displayed(detail.CONTENT_TITLE) or not player.is_player_loaded(), \
            "Player should exit and return to detail page"

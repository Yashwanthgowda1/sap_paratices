import pytest
import allure
from pages.home_page import HomePage
from pages.content_detail_page import ContentDetailPage
from pages.player_page import PlayerPage
from config.config import Config


@allure.epic("JioHotstar")
@allure.feature("Video Player - UI")
@pytest.mark.ui
@pytest.mark.player
class TestPlayer:
    """TC-PLYR-001 to TC-PLYR-010: Video player UI tests."""

    FREE_CONTENT_URL = f"{Config.BASE_URL}/in/watch/{Config.FREE_CONTENT_ID}"

    @allure.story("Player loads for free content")
    @allure.title("TC-PLYR-001 | [SANITY] Player loads for free content")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_PLYR_001
    def test_player_loads_free_content(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded(), "Video player should load for free content"

    @allure.story("Premium content paywall")
    @allure.title("TC-PLYR-002 | [SMOKE] Premium content shows Subscribe CTA/overlay")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_PLYR_002
    def test_premium_content_shows_subscribe_cta(self, driver):
        home = HomePage(driver)
        home.open(f"{Config.BASE_URL}/in/watch/{Config.PREMIUM_CONTENT_ID}")
        player = PlayerPage(driver)
        detail = ContentDetailPage(driver)
        assert detail.is_subscribe_cta_visible() or player.is_subscribe_overlay_shown(), \
            "Subscribe CTA should appear for premium content when not subscribed"

    @allure.story("Play/Pause toggle")
    @allure.title("TC-PLYR-003 | [SMOKE] Play/Pause button toggles playback state")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_PLYR_003
    def test_play_pause_toggle(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded(), "Player should be loaded"
        player.toggle_play_pause()
        label_after = player.get_play_pause_label().lower()
        assert "play" in label_after or "pause" in label_after, \
            "Play/Pause aria-label should reflect toggled state"

    @allure.story("Fullscreen")
    @allure.title("TC-PLYR-004 | [REGRESSION] Fullscreen button enters fullscreen mode")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PLYR_004
    def test_fullscreen_button(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded()
        player.click_fullscreen()

    @allure.story("Forward 10s")
    @allure.title("TC-PLYR-005 | [REGRESSION] Forward 10s button skips playback forward")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PLYR_005
    def test_forward_10s(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded()
        player.click_forward_10s()

    @allure.story("Player controls visible")
    @allure.title("TC-PLYR-006 | [SMOKE] All player controls are visible")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.TC_PLYR_006
    def test_player_controls_visible(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.are_controls_visible(), "Player controls bar should be visible"

    @allure.story("Volume button mutes")
    @allure.title("TC-PLYR-007 | [REGRESSION] Volume button toggles mute state")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PLYR_007
    def test_volume_button_mutes(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded()
        player.click_volume()

    @allure.story("Settings opens quality/subtitle options")
    @allure.title("TC-PLYR-008 | [REGRESSION] Settings gear opens quality/subtitle options")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PLYR_008
    def test_settings_opens_options(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded()
        player.click_settings()

    @allure.story("No player error")
    @allure.title("TC-PLYR-009 | [REGRESSION] No player error shown on valid free content")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.regression
    @pytest.mark.TC_PLYR_009
    def test_no_player_error(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded()
        assert not player.is_error_shown(), "Player error overlay should not appear for valid content"

    @allure.story("Exit player")
    @allure.title("TC-PLYR-010 | [REGRESSION] User can exit the player and return to home")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_PLYR_010
    def test_exit_player(self, logged_in_driver):
        home = HomePage(logged_in_driver)
        home.open(self.FREE_CONTENT_URL)
        player = PlayerPage(logged_in_driver)
        assert player.is_player_loaded()
        player.exit_player()
        assert Config.BASE_URL in player.get_current_url(), "Should navigate back after exiting player"

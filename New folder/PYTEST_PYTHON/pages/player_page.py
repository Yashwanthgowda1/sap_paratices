from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class PlayerPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    VIDEO_PLAYER        = (By.CSS_SELECTOR, "video, [class*='player'], [data-testid='video-player']")
    PLAY_PAUSE_BTN      = (By.CSS_SELECTOR, "[aria-label='Play'], [aria-label='Pause'], [data-testid='play-pause']")
    PROGRESS_BAR        = (By.CSS_SELECTOR, "[class*='progress-bar'], [class*='seekbar'], [data-testid='progress']")
    VOLUME_BTN          = (By.CSS_SELECTOR, "[aria-label='Volume'], [data-testid='volume']")
    VOLUME_SLIDER       = (By.CSS_SELECTOR, "[class*='volume-slider']")
    FULLSCREEN_BTN      = (By.CSS_SELECTOR, "[aria-label='Full screen'], [data-testid='fullscreen']")
    SETTINGS_BTN        = (By.CSS_SELECTOR, "[aria-label='Settings'], [data-testid='settings']")
    QUALITY_OPTION      = (By.CSS_SELECTOR, "[data-testid='quality-option'], [class*='quality']")
    SUBTITLE_BTN        = (By.CSS_SELECTOR, "[aria-label='Subtitles'], [data-testid='subtitles']")
    FORWARD_10S         = (By.CSS_SELECTOR, "[aria-label='Forward 10 seconds'], [data-testid='forward']")
    REWIND_10S          = (By.CSS_SELECTOR, "[aria-label='Rewind 10 seconds'], [data-testid='rewind']")
    NEXT_EPISODE        = (By.CSS_SELECTOR, "[aria-label='Next episode'], [data-testid='next-episode']")
    PLAYER_TITLE        = (By.CSS_SELECTOR, "[class*='player-title'], [data-testid='player-title']")
    LOADING_SPINNER     = (By.CSS_SELECTOR, "[class*='spinner'], [class*='loader'], [data-testid='loading']")
    ERROR_OVERLAY       = (By.CSS_SELECTOR, "[class*='error-overlay'], [data-testid='player-error']")
    PLAYBACK_TIME       = (By.CSS_SELECTOR, "[class*='current-time'], [data-testid='current-time']")
    TOTAL_DURATION      = (By.CSS_SELECTOR, "[class*='duration'], [data-testid='duration']")
    EXIT_PLAYER         = (By.CSS_SELECTOR, "[aria-label='Back'], [data-testid='exit-player']")
    AUTO_PLAY_POPUP     = (By.CSS_SELECTOR, "[class*='auto-play'], [data-testid='autoplay']")
    CAST_BUTTON         = (By.CSS_SELECTOR, "[aria-label='Cast'], [data-testid='cast']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def is_player_loaded(self) -> bool:
        return self.is_displayed(self.VIDEO_PLAYER)

    def is_playing(self) -> bool:
        try:
            return self.driver.execute_script("return !document.querySelector('video').paused;")
        except Exception:
            return False

    def play_pause(self):
        log.info("Toggling play/pause")
        self.click(self.PLAY_PAUSE_BTN)

    def go_fullscreen(self):
        self.click(self.FULLSCREEN_BTN)

    def is_fullscreen(self) -> bool:
        return self.driver.execute_script("return !!document.fullscreenElement;")

    def forward_10s(self):
        self.click(self.FORWARD_10S)

    def rewind_10s(self):
        self.click(self.REWIND_10S)

    def open_settings(self):
        self.click(self.SETTINGS_BTN)

    def toggle_subtitles(self):
        self.click(self.SUBTITLE_BTN)

    def get_current_time(self) -> str:
        return self.get_text(self.PLAYBACK_TIME)

    def get_total_duration(self) -> str:
        return self.get_text(self.TOTAL_DURATION)

    def is_loading(self) -> bool:
        return self.is_displayed(self.LOADING_SPINNER)

    def is_error_shown(self) -> bool:
        return self.is_displayed(self.ERROR_OVERLAY)

    def click_next_episode(self):
        self.click(self.NEXT_EPISODE)

    def exit_player(self):
        self.click(self.EXIT_PLAYER)

    def mute_volume(self):
        self.click(self.VOLUME_BTN)

    def wait_for_player_to_load(self):
        self.wait.wait_for_element_invisible(self.LOADING_SPINNER, timeout=30)

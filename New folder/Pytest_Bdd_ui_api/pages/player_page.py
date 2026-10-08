import time
from selenium.webdriver.common.by import By
from selenium.webdriver.support import expected_conditions as EC
from selenium.webdriver.support.ui import WebDriverWait
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class PlayerPage(BasePage):
    # ── Locators ──────────────────────────────────────────────────────────────
    PLAYER_CONTAINER  = (By.CSS_SELECTOR, "video, [data-testid='player'], [class*='VideoPlayer'], [class*='player-container']")
    PLAY_PAUSE_BTN    = (By.CSS_SELECTOR, "[data-testid='play-pause'], [aria-label*='Pause'], [aria-label*='Play']")
    FULLSCREEN_BTN    = (By.CSS_SELECTOR, "[data-testid='fullscreen'], [aria-label='Fullscreen'], [class*='fullscreen-btn']")
    VOLUME_BTN        = (By.CSS_SELECTOR, "[data-testid='mute'], [aria-label='Mute'], [class*='volume-btn']")
    SETTINGS_BTN      = (By.CSS_SELECTOR, "[data-testid='settings'], [aria-label='Settings'], [class*='settings-btn']")
    SEEK_BAR          = (By.CSS_SELECTOR, "[data-testid='seek-bar'], [class*='progress-bar'], input[type='range']")
    VIDEO_ELEMENT     = (By.TAG_NAME, "video")
    ERROR_OVERLAY     = (By.CSS_SELECTOR, "[class*='player-error'], [data-testid='player-error']")

    # ── Actions ────────────────────────────────────────────────────────────────
    def is_player_visible(self) -> bool:
        return self.is_displayed(self.PLAYER_CONTAINER, timeout=15)

    def wait_for_playback_to_start(self, timeout: int = 10) -> bool:
        deadline = time.time() + timeout
        while time.time() < deadline:
            videos = self.driver.find_elements(*self.VIDEO_ELEMENT)
            if videos:
                current_time = self.driver.execute_script("return arguments[0].currentTime;", videos[0])
                if current_time and float(current_time) > 0:
                    log.info(f"Playback started at {current_time:.1f}s")
                    return True
            time.sleep(0.5)
        return False

    def click_play_pause(self):
        self.click(self.PLAY_PAUSE_BTN)

    def click_fullscreen(self):
        self.click(self.FULLSCREEN_BTN)

    def click_mute(self):
        self.click(self.VOLUME_BTN)

    def is_error_displayed(self) -> bool:
        return self.is_displayed(self.ERROR_OVERLAY, timeout=3)

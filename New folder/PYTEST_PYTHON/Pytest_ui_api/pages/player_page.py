from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class PlayerPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    PLAYER_CONTAINER = (By.CSS_SELECTOR, "[class*='player'], video, [data-testid='player']")
    PLAY_PAUSE_BTN   = (By.CSS_SELECTOR, "[aria-label*='Play'], [aria-label*='Pause'], [data-testid='play-pause']")
    FULLSCREEN_BTN   = (By.CSS_SELECTOR, "[aria-label='Fullscreen'], [data-testid='fullscreen-btn']")
    FORWARD_BTN      = (By.CSS_SELECTOR, "[aria-label*='Forward 10'], [data-testid='forward-btn']")
    VOLUME_BTN       = (By.CSS_SELECTOR, "[aria-label*='Mute'], [aria-label*='Volume'], [data-testid='volume-btn']")
    SETTINGS_BTN     = (By.CSS_SELECTOR, "[aria-label='Settings'], [data-testid='settings-btn']")
    BACK_BUTTON      = (By.CSS_SELECTOR, "[aria-label='Back'], [class*='back-btn']")
    PLAYER_CONTROLS  = (By.CSS_SELECTOR, "[class*='controls'], [data-testid='player-controls']")
    ERROR_OVERLAY    = (By.CSS_SELECTOR, "[class*='error-overlay'], [data-testid='player-error']")
    SUBSCRIBE_OVERLAY = (By.CSS_SELECTOR, "[class*='subscribe-overlay'], [data-testid='paywall']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def is_player_loaded(self) -> bool:
        return self.is_displayed(self.PLAYER_CONTAINER)

    def toggle_play_pause(self):
        self.click(self.PLAY_PAUSE_BTN)

    def get_play_pause_label(self) -> str:
        return self.get_attribute(self.PLAY_PAUSE_BTN, "aria-label") or ""

    def click_fullscreen(self):
        self.click(self.FULLSCREEN_BTN)

    def click_forward_10s(self):
        self.click(self.FORWARD_BTN)

    def click_volume(self):
        self.click(self.VOLUME_BTN)

    def click_settings(self):
        self.click(self.SETTINGS_BTN)

    def exit_player(self):
        self.click(self.BACK_BUTTON)

    def are_controls_visible(self) -> bool:
        return self.is_displayed(self.PLAYER_CONTROLS)

    def is_error_shown(self) -> bool:
        return self.is_displayed(self.ERROR_OVERLAY)

    def is_subscribe_overlay_shown(self) -> bool:
        return self.is_displayed(self.SUBSCRIBE_OVERLAY)

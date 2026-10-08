from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class ContinueWatchingPage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    CONTINUE_WATCHING_TRAY  = (By.CSS_SELECTOR, "[data-testid='continue-watching'], [class*='continue-watching']")
    TRAY_TITLE              = (By.XPATH, "//*[contains(text(),'Continue Watching') or contains(text(),'Resume')]")
    TRAY_ITEMS              = (By.CSS_SELECTOR, "[data-testid='cw-item'], [class*='continue-item']")
    RESUME_BTN              = (By.CSS_SELECTOR, "[data-testid='resume-btn'], [aria-label*='Resume']")
    PROGRESS_BAR            = (By.CSS_SELECTOR, "[data-testid='progress-bar'], [class*='progress']")
    REMOVE_FROM_CW          = (By.CSS_SELECTOR, "[data-testid='remove-cw'], [aria-label='Remove']")
    CONTENT_THUMBNAIL       = (By.CSS_SELECTOR, "[data-testid='cw-thumbnail'], [class*='thumbnail']")
    CONTENT_TITLE_IN_TRAY   = (By.CSS_SELECTOR, "[data-testid='cw-title'], [class*='item-title']")
    EPISODE_LABEL           = (By.CSS_SELECTOR, "[data-testid='episode-label'], [class*='episode']")

    # ── Actions ───────────────────────────────────────────────────────────────
    def is_tray_visible(self) -> bool:
        return self.is_displayed(self.CONTINUE_WATCHING_TRAY)

    def get_tray_items(self) -> list:
        return self.get_all_elements(self.TRAY_ITEMS)

    def get_item_count(self) -> int:
        return len(self.get_tray_items())

    def click_resume(self):
        log.info("Clicking Resume button on first item")
        self.click(self.RESUME_BTN)

    def is_progress_bar_visible(self) -> bool:
        return self.is_displayed(self.PROGRESS_BAR)

    def remove_first_item(self):
        log.info("Removing first item from Continue Watching tray")
        items = self.get_all_elements(self.REMOVE_FROM_CW)
        if items:
            items[0].click()

    def get_item_titles(self) -> list:
        return [el.text for el in self.get_all_elements(self.CONTENT_TITLE_IN_TRAY)]

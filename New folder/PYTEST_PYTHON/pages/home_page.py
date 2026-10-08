from selenium.webdriver.common.by import By
from pages.base_page import BasePage
from utilities.logger import get_logger

log = get_logger(__name__)


class HomePage(BasePage):
    # ── Locators ─────────────────────────────────────────────────────────────
    LOGO                = (By.CSS_SELECTOR, "[class*='logo'], [data-testid='logo']")
    SEARCH_ICON         = (By.CSS_SELECTOR, "[aria-label='Search'], [data-testid='search']")
    NAV_HOME            = (By.XPATH, "//nav//a[contains(text(),'Home')]")
    NAV_MOVIES          = (By.XPATH, "//nav//a[contains(text(),'Movies')]")
    NAV_SHOWS           = (By.XPATH, "//nav//a[contains(text(),'Shows') or contains(text(),'TV Shows')]")
    NAV_SPORTS          = (By.XPATH, "//nav//a[contains(text(),'Sports')]")
    NAV_LIVE_TV         = (By.XPATH, "//nav//a[contains(text(),'Live')]")
    HERO_BANNER         = (By.CSS_SELECTOR, "[class*='hero'], [data-testid='hero-banner']")
    HERO_PLAY_BTN       = (By.CSS_SELECTOR, "[class*='hero'] button[aria-label*='Play'], [data-testid='hero-play']")
    HERO_TITLE          = (By.CSS_SELECTOR, "[class*='hero'] [class*='title']")
    CONTENT_TRAY        = (By.CSS_SELECTOR, "[class*='tray'], [class*='shelf'], [data-testid='content-tray']")
    CONTENT_CARD        = (By.CSS_SELECTOR, "[class*='card'], [class*='tile'], [data-testid='content-card']")
    CONTINUE_WATCHING   = (By.XPATH, "//*[contains(text(),'Continue Watching')]")
    TRENDING_NOW        = (By.XPATH, "//*[contains(text(),'Trending')]")
    FOOTER              = (By.CSS_SELECTOR, "footer")
    LANGUAGE_SELECTOR   = (By.CSS_SELECTOR, "[data-testid='language-selector'], [aria-label='Language']")
    NOTIFICATION_BELL   = (By.CSS_SELECTOR, "[aria-label='Notifications']")
    SUBSCRIBE_BUTTON    = (By.XPATH, "//button[contains(text(),'Subscribe')]")

    # ── Actions ───────────────────────────────────────────────────────────────
    def open_home(self):
        self.open()
        log.info("Opening home page")

    def is_home_page_loaded(self) -> bool:
        return self.is_displayed(self.LOGO) and self.is_displayed(self.HERO_BANNER)

    def get_hero_title(self) -> str:
        return self.get_text(self.HERO_TITLE)

    def click_hero_play(self):
        log.info("Clicking hero banner play button")
        self.click(self.HERO_PLAY_BTN)

    def navigate_to_movies(self):
        self.click(self.NAV_MOVIES)

    def navigate_to_shows(self):
        self.click(self.NAV_SHOWS)

    def navigate_to_sports(self):
        self.click(self.NAV_SPORTS)

    def navigate_to_live_tv(self):
        self.click(self.NAV_LIVE_TV)

    def click_search(self):
        self.click(self.SEARCH_ICON)

    def get_content_trays(self) -> list:
        return self.get_all_elements(self.CONTENT_TRAY)

    def is_section_present(self, section_name: str) -> bool:
        locator = (By.XPATH, f"//*[contains(text(),'{section_name}')]")
        return self.is_displayed(locator)

    def click_content_card(self, index: int = 0):
        cards = self.get_all_elements(self.CONTENT_CARD)
        cards[index].click()

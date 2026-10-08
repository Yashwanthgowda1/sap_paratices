"""
pages/home_page.py
------------------
All locators and actions for the Hotstar Home page.
Tests never use By/CSS/XPath directly — they call methods here.
"""

from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
from tests.hotstar.pages.base_page import BasePage


class HomePage(BasePage):

    URL = "https://www.hotstar.com/in"

    # ── Locators ──────────────────────────────────────────────────────────────
    # change only here if the website updates its HTML

    _SEARCH_ICON     = (By.CSS_SELECTOR, "[data-testid='search']")
    _SEARCH_INPUT    = (By.CSS_SELECTOR, "input[placeholder*='Search']")
    _SEARCH_RESULTS  = (By.CSS_SELECTOR, "[data-testid='search-result-item']")

    _NAV_HOME        = (By.XPATH, "//a[normalize-space()='Home']")
    _NAV_TV          = (By.XPATH, "//a[normalize-space()='TV']")
    _NAV_MOVIES      = (By.XPATH, "//a[normalize-space()='Movies']")
    _NAV_SPORTS      = (By.XPATH, "//a[normalize-space()='Sports']")
    _NAV_CATEGORIES  = (By.XPATH, "//a[normalize-space()='Categories']")

    _HERO_BANNER     = (By.CSS_SELECTOR, "[data-testid='hero-banner']")
    _TRAY_TITLE      = (By.CSS_SELECTOR, "[data-testid='tray-title']")
    _CONTENT_CARD    = (By.CSS_SELECTOR, "[data-testid='content-card']")

    _LOGIN_BUTTON    = (By.XPATH, "//button[contains(text(),'Log in')]")
    _PROFILE_ICON    = (By.CSS_SELECTOR, "[data-testid='user-profile']")

    # ── Page actions ──────────────────────────────────────────────────────────

    def load(self):
        """Open Hotstar home page."""
        self.open(self.URL)

    def is_home_page_loaded(self) -> bool:
        return "hotstar" in self.get_current_url()

    # ── Navigation bar ────────────────────────────────────────────────────────

    def click_home(self):
        self.click(*self._NAV_HOME)

    def click_tv(self):
        self.click(*self._NAV_TV)

    def click_movies(self):
        self.click(*self._NAV_MOVIES)

    def click_sports(self):
        self.click(*self._NAV_SPORTS)

    def click_categories(self):
        self.click(*self._NAV_CATEGORIES)

    def get_current_nav_url(self) -> str:
        return self.get_current_url()

    # ── Search ────────────────────────────────────────────────────────────────

    def click_search_icon(self):
        self.click(*self._SEARCH_ICON)

    def type_in_search(self, text: str):
        self.type_text(*self._SEARCH_INPUT, text)

    def press_enter_on_search(self):
        element = self.wait_for_element(*self._SEARCH_INPUT)
        element.send_keys(Keys.RETURN)

    def search(self, keyword: str):
        """Click search icon → type keyword → press Enter."""
        self.click_search_icon()
        self.type_in_search(keyword)
        self.press_enter_on_search()

    def get_search_results(self) -> list:
        """Return list of visible search result elements."""
        return self.driver.find_elements(*self._SEARCH_RESULTS)

    def is_search_result_visible(self) -> bool:
        return self.is_element_visible(*self._SEARCH_RESULTS)

    # ── Home content ──────────────────────────────────────────────────────────

    def is_hero_banner_visible(self) -> bool:
        return self.is_element_visible(*self._HERO_BANNER)

    def get_tray_titles(self) -> list:
        """Return text of all content tray headings on the home page."""
        elements = self.driver.find_elements(*self._TRAY_TITLE)
        return [e.text for e in elements if e.text]

    def get_content_cards(self) -> list:
        return self.driver.find_elements(*self._CONTENT_CARD)

    def click_content_card(self, index: int = 0):
        cards = self.get_content_cards()
        assert len(cards) > index, f"No card at index {index}"
        cards[index].click()

    # ── Auth ──────────────────────────────────────────────────────────────────

    def is_login_button_visible(self) -> bool:
        return self.is_element_visible(*self._LOGIN_BUTTON)

    def click_login(self):
        self.click(*self._LOGIN_BUTTON)

    def is_logged_in(self) -> bool:
        return self.is_element_visible(*self._PROFILE_ICON)

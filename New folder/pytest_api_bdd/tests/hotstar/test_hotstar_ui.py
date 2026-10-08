"""
test_hotstar_ui.py
------------------
Normal pytest UI tests for Hotstar website.
No BDD — just plain test classes with Given/When/Then in comments.

All browser actions go through Page Objects (HomePage, SearchPage).
Tests never use driver.find_element() directly.

Run:
    pytest tests/hotstar/test_hotstar_ui.py -v
    pytest tests/hotstar/test_hotstar_ui.py -v -k "search"
"""

import pytest
from utils.data_loader import load_json

DATA = load_json("hotstar_data.json")


# ─────────────────────────────────────────────────────────────────────────────
#  TestHomePageLoad
# ─────────────────────────────────────────────────────────────────────────────

class TestHomePageLoad:

    def test_hotstar_home_page_title(self, home_page):
        # Given  browser is open
        # When   Hotstar home page is loaded  (done by home_page fixture)
        # Then   page title contains "Hotstar"
        assert "Hotstar" in home_page.get_title(), (
            f"Expected 'Hotstar' in title, got: {home_page.get_title()}"
        )

    def test_home_page_url_is_correct(self, home_page):
        assert "hotstar.com" in home_page.get_current_url()

    def test_login_button_is_visible(self, home_page):
        assert home_page.is_login_button_visible(), "Login button not visible"

    def test_home_page_has_content_trays(self, home_page):
        trays = home_page.get_tray_titles()
        assert len(trays) > 0, "No content trays found on home page"


# ─────────────────────────────────────────────────────────────────────────────
#  TestNavigation — click nav bar items, verify URL changes
# ─────────────────────────────────────────────────────────────────────────────

class TestNavigation:

    def test_click_tv_navigates_to_tv_page(self, home_page):
        # Given  home page is loaded
        # When   I click the TV nav item
        home_page.click_tv()
        # Then   URL contains "tv"
        assert "tv" in home_page.get_current_url().lower(), (
            f"Expected 'tv' in URL, got: {home_page.get_current_url()}"
        )

    def test_click_movies_navigates_to_movies_page(self, home_page):
        home_page.click_movies()
        assert "movies" in home_page.get_current_url().lower(), (
            f"Expected 'movies' in URL, got: {home_page.get_current_url()}"
        )

    def test_click_sports_navigates_to_sports_page(self, home_page):
        home_page.click_sports()
        assert "sports" in home_page.get_current_url().lower(), (
            f"Expected 'sports' in URL, got: {home_page.get_current_url()}"
        )

    def test_click_home_returns_to_home(self, home_page):
        # When   navigate away then click Home
        home_page.click_tv()
        home_page.click_home()
        # Then   URL is back to home
        assert "hotstar.com/in" in home_page.get_current_url()


# ─────────────────────────────────────────────────────────────────────────────
#  TestSearch — search icon → type → results
# ─────────────────────────────────────────────────────────────────────────────

class TestSearch:

    def test_search_icon_opens_search_box(self, home_page):
        # Given  home page is loaded
        # When   I click the search icon
        home_page.click_search_icon()
        # Then   search input box is visible
        assert home_page.is_element_visible(
            *home_page._SEARCH_INPUT
        ), "Search input not visible after clicking search icon"

    def test_search_for_cricket_shows_results(self, home_page, search_page):
        # Given  home page loaded
        # When   I search for "Cricket"
        home_page.search("Cricket")
        # Then   search results appear
        assert search_page.get_result_count() > 0, "No results for 'Cricket'"

    def test_search_result_page_url_contains_query(self, home_page, search_page):
        home_page.search("Avengers")
        assert "search" in search_page.get_current_url().lower() or \
               "avengers" in search_page.get_current_url().lower()

    @pytest.mark.parametrize("keyword", DATA["search_titles"])
    def test_search_each_keyword_returns_results(self, home_page, search_page, keyword):
        """
        Runs once per keyword in hotstar_data.json → search_titles.
        keyword = "Avengers" → run 1
        keyword = "Hotstar"  → run 2
        keyword = "Cricket"  → run 3
        """
        # Given  home page loaded  (done by fixture)
        # When   I search for the keyword
        home_page.search(keyword)
        # Then   at least 1 result shown OR no-results message shown
        has_results   = search_page.get_result_count() > 0
        no_result_msg = search_page.is_no_results_shown()
        assert has_results or no_result_msg, (
            f"Search for '{keyword}': no results and no 'no-results' message"
        )

    def test_click_first_search_result_opens_content(self, home_page, search_page):
        # Given  search results shown
        home_page.search("Cricket")
        result_count = search_page.get_result_count()
        if result_count == 0:
            pytest.skip("No search results returned — skipping click test")
        # When   I click the first result
        search_page.click_first_result()
        # Then   URL changes (navigated to content page)
        assert home_page.get_current_url() != "https://www.hotstar.com/in"


# ─────────────────────────────────────────────────────────────────────────────
#  TestCategories — click Categories, select one
# ─────────────────────────────────────────────────────────────────────────────

class TestCategories:

    def test_click_categories_nav(self, home_page):
        # Given  home page loaded
        # When   I click Categories
        home_page.click_categories()
        # Then   URL changes to categories page
        assert "categor" in home_page.get_current_url().lower(), (
            f"Expected categories in URL, got: {home_page.get_current_url()}"
        )

    def test_content_cards_visible_on_home(self, home_page):
        cards = home_page.get_content_cards()
        assert len(cards) > 0, "No content cards found on home page"

    def test_click_content_card_navigates(self, home_page):
        cards = home_page.get_content_cards()
        if not cards:
            pytest.skip("No content cards found")
        # When   I click the first content card
        home_page.click_content_card(index=0)
        # Then   URL changed from home
        assert home_page.get_current_url() != "https://www.hotstar.com/in"

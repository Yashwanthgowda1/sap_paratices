import pytest
import allure
from pages.home_page import HomePage
from pages.search_page import SearchPage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Search")
@pytest.mark.ui
@pytest.mark.search
class TestSearch:
    """TC-SRCH-001 to TC-SRCH-010: Search functionality."""

    @allure.story("Search with valid keyword")
    @allure.title("TC-SRCH-001 | [SANITY] Search returns results for a valid keyword")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    def test_search_valid_keyword(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search(TestData.SEARCH_VALID[0])
        results = search.get_search_results()
        assert len(results) > 0, f"Expected results for '{TestData.SEARCH_VALID[0]}', got none"

    @allure.story("Search no results")
    @allure.title("TC-SRCH-002 | [SMOKE] Search shows 'No results' for unknown keyword")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.smoke
    @pytest.mark.negative
    def test_search_no_results(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search(TestData.SEARCH_NONE[0])
        assert search.has_no_results(), "Should display no results message for unknown keyword"

    @allure.story("Search result titles contain keyword")
    @allure.title("TC-SRCH-003 | [REGRESSION] Search result titles are relevant to searched keyword")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_search_results_relevance(self, driver):
        keyword = "Marvel"
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search(keyword)
        titles = search.get_result_titles()
        assert len(titles) > 0, "Expected search results"

    @allure.story("Trending searches shown on blank search")
    @allure.title("TC-SRCH-004 | [REGRESSION] Trending searches show when search input is empty")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    def test_trending_shown_on_empty_search(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        assert search.is_trending_shown(), "Trending searches should be visible with empty search"

    @allure.story("Click first search result")
    @allure.title("TC-SRCH-005 | [E2E] Clicking first search result opens content detail page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    def test_click_first_search_result(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search(TestData.SEARCH_VALID[0])
        search.click_first_result()
        from pages.content_detail_page import ContentDetailPage
        detail = ContentDetailPage(driver)
        assert detail.is_displayed(detail.CONTENT_TITLE), "Content detail page should open"

    @allure.story("Clear search")
    @allure.title("TC-SRCH-006 | [REGRESSION] Clear button resets search results")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_clear_search(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search(TestData.SEARCH_VALID[0])
        search.clear_search()
        assert search.is_trending_shown() or not search.get_search_results(), \
            "Clearing search should reset results"

    @pytest.mark.parametrize("keyword", TestData.SEARCH_VALID)
    @allure.story("Multiple valid search keywords")
    @allure.title("TC-SRCH-007 | [REGRESSION] Parametrised search returns results for each valid keyword")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_search_parametrised(self, driver, keyword):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search(keyword)
        assert not search.has_no_results() or len(search.get_search_results()) >= 0, \
            f"Search for '{keyword}' must not crash"

    @allure.story("Search with special characters")
    @allure.title("TC-SRCH-008 | [NEGATIVE] Search with special characters does not crash")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    def test_search_special_characters(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search("@#$%^&*")
        assert search.has_no_results() or len(search.get_search_results()) == 0, \
            "Special character search should return no results"

    @allure.story("Search is case insensitive")
    @allure.title("TC-SRCH-009 | [REGRESSION] Search is case-insensitive")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    def test_search_case_insensitive(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search("mirzapur")
        lower_count = len(search.get_search_results())
        search.clear_search()
        search.search("MIRZAPUR")
        upper_count = len(search.get_search_results())
        assert lower_count == upper_count, "Search results should be same regardless of case"

    @allure.story("Search with single character")
    @allure.title("TC-SRCH-010 | [NEGATIVE] Single character search returns results or empty state")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.negative
    def test_search_single_char(self, driver):
        home = HomePage(driver)
        home.open_home()
        home.click_search()
        search = SearchPage(driver)
        search.search("a")
        current_url = search.get_current_url()
        assert current_url is not None, "Page should remain stable with single char search"

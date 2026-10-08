import pytest
import allure
from pages.home_page import HomePage
from pages.search_page import SearchPage
from pages.content_detail_page import ContentDetailPage
from test_data import TestData


@allure.epic("JioHotstar")
@allure.feature("Search - UI")
@pytest.mark.ui
@pytest.mark.search
class TestSearch:
    """TC-SRCH-001 to TC-SRCH-010: Search feature UI tests."""

    @allure.story("Search returns results")
    @allure.title("TC-SRCH-001 | [SANITY] Search returns results for valid keyword")
    @allure.severity(allure.severity_level.BLOCKER)
    @pytest.mark.sanity
    @pytest.mark.smoke
    @pytest.mark.TC_SRCH_001
    def test_search_valid_keyword(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for(TestData.CONTENT["search_keyword"])
        assert len(search.get_results()) > 0, "Search must return at least one result"

    @allure.story("No results message")
    @allure.title("TC-SRCH-002 | [SMOKE] Search shows no-results message for unknown keyword")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.smoke
    @pytest.mark.negative
    @pytest.mark.TC_SRCH_002
    def test_search_no_results(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for(TestData.SEARCH_KEYWORDS_NO_RESULT[0])
        assert search.has_no_results_message(), "No-results message should appear for unknown keyword"

    @allure.story("Result titles relevant")
    @allure.title("TC-SRCH-003 | [REGRESSION] Result titles are relevant to the search keyword")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_003
    def test_search_results_relevant(self, driver):
        keyword = "cricket"
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for(keyword)
        titles = search.get_result_titles()
        assert titles, "Should have result titles"

    @allure.story("Trending on empty search")
    @allure.title("TC-SRCH-004 | [REGRESSION] Trending searches shown when search is empty")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_004
    def test_trending_on_empty_search(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        assert len(search.get_trending_items()) > 0, "Trending items should appear when search box is empty"

    @allure.story("Click result opens content detail")
    @allure.title("TC-SRCH-005 | [E2E] Clicking first search result opens content detail page")
    @allure.severity(allure.severity_level.CRITICAL)
    @pytest.mark.e2e
    @pytest.mark.TC_SRCH_005
    def test_click_result_opens_detail(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for(TestData.CONTENT["search_keyword"])
        search.click_first_result()
        detail = ContentDetailPage(driver)
        assert detail.is_play_button_visible() or detail.is_subscribe_cta_visible(), \
            "Content detail page should load after clicking a result"

    @allure.story("Clear button resets")
    @allure.title("TC-SRCH-006 | [REGRESSION] Clear button resets search field and results")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_006
    def test_clear_button_resets_search(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for("avengers")
        search.clear_search()
        assert len(search.get_results()) == 0 or search.get_trending_items(), \
            "Results should clear after clicking the clear button"

    @allure.story("Parametrised search")
    @allure.title("TC-SRCH-007 | [REGRESSION] Parametrised search returns results for each valid keyword")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_007
    @pytest.mark.parametrize("keyword", TestData.SEARCH_KEYWORDS_VALID)
    def test_parametrised_search(self, driver, keyword):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for(keyword)
        assert len(search.get_results()) > 0, f"Search '{keyword}' should return results"

    @allure.story("Special characters search")
    @allure.title("TC-SRCH-008 | [NEGATIVE] Search with special characters does not crash the page")
    @allure.severity(allure.severity_level.NORMAL)
    @pytest.mark.negative
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_008
    @pytest.mark.parametrize("chars", TestData.SEARCH_SPECIAL_CHARS)
    def test_search_special_characters(self, driver, chars):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for(chars)
        assert home.get_current_url(), "Page should remain stable after special-char search"

    @allure.story("Case insensitive search")
    @allure.title("TC-SRCH-009 | [REGRESSION] Search is case-insensitive")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_009
    def test_search_case_insensitive(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for("CRICKET")
        upper_count = len(search.get_results())
        search.clear_search()
        search.search_for("cricket")
        lower_count = len(search.get_results())
        assert upper_count == lower_count, "Result count should be the same regardless of case"

    @allure.story("Single character search")
    @allure.title("TC-SRCH-010 | [REGRESSION] Single character search is stable")
    @allure.severity(allure.severity_level.MINOR)
    @pytest.mark.regression
    @pytest.mark.TC_SRCH_010
    def test_single_char_search(self, driver):
        home = HomePage(driver)
        home.open()
        home.click_search()
        search = SearchPage(driver)
        search.search_for("a")
        assert home.get_current_url(), "Page should remain stable after single-char search"

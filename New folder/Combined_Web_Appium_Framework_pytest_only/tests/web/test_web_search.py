import pytest
import allure


@allure.feature("Web Search")
class TestWebSearch:
    """Web search test suite — uses login_page + search_page fixtures."""

    @allure.story("Search returns results")
    @allure.severity(allure.severity_level.CRITICAL)
    def test_search_valid_keyword_returns_results(self, login_page, search_page, soft_assert):
        login_page.open_login_page()
        login_page.login_with_defaults()
        search_page.search_for("Avengers")

        soft_assert.assert_true(
            search_page.get_results_count() > 0,
            "Should return at least one result"
        )
        soft_assert.assert_false(
            search_page.is_no_results_shown(),
            "'No results' message should NOT appear"
        )
        soft_assert.assert_all()

    @allure.story("No results for invalid keyword")
    def test_search_gibberish_shows_no_results(self, login_page, search_page):
        login_page.open_login_page()
        login_page.login_with_defaults()
        search_page.search_for("xyzxyzxyz123notreal")
        assert search_page.is_no_results_shown(), "Should show 'No results' message"

    @allure.story("Search result titles contain keyword")
    def test_search_results_relevant_to_keyword(self, login_page, search_page):
        keyword = "Batman"
        login_page.open_login_page()
        login_page.login_with_defaults()
        search_page.search_for(keyword)

        titles = search_page.get_all_result_titles()
        assert len(titles) > 0, "Expected search results"
        assert any(keyword.lower() in t.lower() for t in titles), \
            f"At least one result should contain '{keyword}'"

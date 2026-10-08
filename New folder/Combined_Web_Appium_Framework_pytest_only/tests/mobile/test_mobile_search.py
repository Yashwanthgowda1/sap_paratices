import pytest
import allure


@allure.feature("Mobile Search")
class TestMobileSearch:
    """
    Mobile search test suite — demonstrates scroll, swipe in real tests.
    Requires logged-in state — uses mobile_logged_in_driver fixture.
    """

    @allure.story("Search returns results on Android")
    @allure.severity(allure.severity_level.CRITICAL)
    def test_search_returns_results(self, mobile_home_page, mobile_search_page):
        mobile_home_page.tap_search()
        mobile_search_page.search_for("Batman")
        assert mobile_search_page.get_results_count() > 0, \
            "Search should return results for 'Batman'"

    @allure.story("Scroll through search results")
    def test_scroll_through_results(self, mobile_home_page, mobile_search_page):
        mobile_home_page.tap_search()
        mobile_search_page.search_for("Marvel")
        count_before = mobile_search_page.get_results_count()

        # Scroll down to load more results
        mobile_search_page.gesture.scroll_down(distance=0.6)
        count_after = mobile_search_page.get_results_count()

        assert count_after >= count_before, \
            "Scrolling should reveal more results or same count"

    @allure.story("Scroll to specific result")
    def test_scroll_to_specific_result(self, mobile_home_page, mobile_search_page):
        mobile_home_page.tap_search()
        mobile_search_page.search_for("Avengers")
        element = mobile_search_page.scroll_to_result("Avengers: Endgame")
        assert element is not None, "Should find 'Avengers: Endgame' after scrolling"

    @allure.story("No results for invalid keyword")
    def test_no_results_for_gibberish(self, mobile_home_page, mobile_search_page):
        mobile_home_page.tap_search()
        mobile_search_page.search_for("xyzxyz123notreal")
        assert mobile_search_page.is_no_results_shown(), \
            "Should show no results message"

    @allure.story("Swipe carousel on home screen")
    def test_swipe_home_carousel(self, mobile_home_page):
        assert mobile_home_page.is_home_loaded(), "Home should be loaded"
        mobile_home_page.swipe_carousel_left()
        mobile_home_page.swipe_carousel_left()
        mobile_home_page.swipe_carousel_right()
        assert mobile_home_page.is_home_loaded(), "Home should still be visible after swipes"

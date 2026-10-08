"""
Step definitions for:  features/search/search.feature
Feature               : Search – JioHotstar
BDD scenario IDs      : BDD_SRCH_001 … BDD_SRCH_008

Fixtures used (all defined in conftest.py):
    driver       → live ChromeDriver instance
    search_page  → SearchPage(driver)   ← page object
    home_page    → HomePage(driver)     ← page object
    context      → {} dict shared between steps of one scenario
    soft_assert  → SoftAssert()         ← collects all failures, raises at end
"""
import pytest
import allure
from pytest_bdd import scenarios, given, when, then, parsers

from utilities.logger import get_logger

log = get_logger(__name__)

# ── Bind ALL scenarios in search.feature to this module ───────────────────────
#    pytest-bdd auto-generates one test function per Scenario / Outline row.
#    The generated function name  =  item.name  inside the screenshot hook.
#
#    e.g.  "BDD_SRCH_001 | [SANITY] Valid keyword returns search results"
#           → test_bdd_srch_001___sanity__valid_keyword_returns_search_results
# ─────────────────────────────────────────────────────────────────────────────
scenarios("search/search.feature")


# ══════════════════════════════════════════════════════════════════════════════
# SHARED STATE FIXTURE
# same pattern as test_content_playback.py — one fresh dict per scenario
# ══════════════════════════════════════════════════════════════════════════════

@pytest.fixture
def context():
    return {}


# ══════════════════════════════════════════════════════════════════════════════
# BACKGROUND STEPS
# These run before every scenario in this feature (same as Gherkin Background)
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Open JioHotstar home page")
@given("the JioHotstar home page is open")
def step_open_home(driver):
    """
    driver  ← injected by pytest from conftest.py
              conftest defines:  def driver(browser_name, headless): ...
              pytest sees 'driver' parameter here → creates ChromeDriver → passes in
    """
    from pages.home_page import HomePage
    HomePage(driver).open()
    log.info("Home page opened")


@allure.step("Click search icon")
@given("the search icon is clicked")
def step_click_search_icon(driver):
    """
    Same driver instance as above — pytest reuses the function-scoped fixture
    within one scenario.  Both Background steps share the same browser tab.
    """
    from pages.home_page import HomePage
    HomePage(driver).click_search_icon()
    log.info("Search icon clicked — search box should be visible now")


# ══════════════════════════════════════════════════════════════════════════════
# WHEN – actions
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Type '{keyword}' in search box")
@when(parsers.parse('I type "{keyword}" in the search box'))
def step_type_keyword(keyword, search_page, context):
    """
    search_page ← injected by pytest from conftest.py
                  conftest defines:  def search_page(driver): return SearchPage(driver)
                  pytest sees 'search_page' parameter → calls that fixture → passes in

    context     ← injected by pytest — the {} dict defined above
                  we store keyword here so @then steps can read it back
    """
    search_page.enter_search_query(keyword)
    context["keyword"] = keyword                # store for later @then steps
    log.info(f"Typed keyword: '{keyword}'")


@allure.step("Click first result from search")
@when("I click the first result from search")
def step_click_first_result(search_page, context):
    """
    search_page — same SearchPage object pytest already created for this scenario.
    We also save the title into context so the @then can verify the detail page.
    """
    title = search_page.get_first_result_title()
    context["clicked_title"] = title            # store title before navigating away
    search_page.click_first_result()
    log.info(f"Clicked first result: '{title}'")


@allure.step("Clear the search input")
@when("I clear the search input")
def step_clear_search(search_page):
    search_page.clear_search_input()
    log.info("Search input cleared")


# ══════════════════════════════════════════════════════════════════════════════
# THEN – assertions
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Assert: search results page is displayed")
@then("the search results page is displayed")
def step_assert_results_page(search_page):
    """
    search_page — same instance injected by pytest (not re-created).
    Calls has_results() which checks RESULT_ITEMS locator via BasePage.find_elements().
    """
    assert search_page.has_results(), "Search results page shows no items"
    log.info("Search results page confirmed visible")


@allure.step("Assert: at least 1 result is shown")
@then("at least 1 result is shown")
def step_assert_at_least_one(search_page):
    count = search_page.get_result_count()
    assert count >= 1, f"Expected at least 1 result, got {count}"
    log.info(f"Result count: {count}")


@allure.step("Assert: 0 result items shown")
@then("0 result items are shown")
def step_assert_zero_results(search_page):
    count = search_page.get_result_count()
    assert count == 0, f"Expected 0 results for unknown keyword, got {count}"


@allure.step("Assert: no-results message is displayed")
@then("the no-results message is displayed")
def step_assert_no_results_message(search_page):
    assert search_page.is_no_results_message_shown(), (
        "No 'no-results' message visible for unknown keyword"
    )


@allure.step("Assert: all result titles contain keyword")
@then(parsers.parse('all result titles contain the keyword "{keyword}"'))
def step_assert_all_titles_contain(keyword, search_page, soft_assert):
    # ─── soft_assert injected from conftest ───────────────────────────────────
    # conftest.py defines:
    #   @pytest.fixture
    #   def soft_assert():
    #       sa = SoftAssert()
    #       yield sa
    #       sa.assert_all()   ← raises ONE combined error AFTER this step returns
    #
    # WITHOUT soft_assert (hard assert):
    #   titles = ["Avengers 1", "Batman", "Avengers 2"]
    #   fails on "Batman" → stops → never checks "Avengers 2"
    #   you only see 1 failure
    #
    # WITH soft_assert:
    #   checks every title → collects ALL failures
    #   you see: "2 soft assertion(s) failed: 1. Batman  2. Superman"
    # ─────────────────────────────────────────────────────────────────────────
    titles = search_page.get_all_result_titles()

    # hard assert — if 0 titles, no point continuing
    assert len(titles) > 0, "No titles found to validate"

    for title in titles:
        soft_assert.assert_contains(
            text=title.lower(),
            substring=keyword.lower(),
            msg=f"Title '{title}' should contain '{keyword}'"
        )
        # ↑ does NOT raise — just appends to SoftAssert._failures list
        # conftest sa.assert_all() raises at the very end with ALL failures

    log.info(f"Checked {len(titles)} titles against keyword '{keyword}'")


@allure.step("Assert: first result title contains expected text")
@then(parsers.parse('the first result title contains "{expected}"'))
def step_assert_first_title_contains(expected, search_page, soft_assert):
    # Used by BDD_SRCH_008 Scenario Outline — runs once per Examples row:
    #   | Avengers | Avengers |
    #   | Animal   | Animal   |
    #   | Cricket  | Cricket  |
    #   | Aarya    | Aarya    |
    #
    # Each row is a separate test function generated by pytest-bdd.
    # soft_assert here checks 3 things about the first result in one pass —
    # if title is empty AND doesn't contain expected AND has wrong length
    # you see ALL 3 failures instead of stopping at the first.
    title = search_page.get_first_result_title()

    soft_assert.assert_true(
        len(title) > 0,
        msg="First result title should not be empty"
    )
    soft_assert.assert_contains(
        text=title.lower(),
        substring=expected.lower(),
        msg=f"First result title '{title}' should contain '{expected}'"
    )
    soft_assert.assert_true(
        len(title) < 200,
        msg=f"Title looks malformed (too long): '{title[:50]}...'"
    )
    # soft_assert.assert_all() is called automatically by conftest fixture teardown
    log.info(f"Soft-checked first title '{title}' against expected '{expected}'")


@allure.step("Assert: content detail page is loaded")
@then("the content detail page is loaded")
def step_assert_detail_page(driver):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    assert detail.is_loaded(), "Content detail page did not load after clicking search result"


@allure.step("Assert: search results cleared or input is empty")
@then("the search results are cleared or the search input is empty")
def step_assert_results_cleared(search_page):
    count = search_page.get_result_count()
    assert count == 0 or not search_page.has_results(), (
        f"Expected 0 results after clearing, but got {count}"
    )


@allure.step("Assert: page did not crash")
@then("the page does not crash")
def step_assert_no_crash(driver):
    assert "error" not in driver.title.lower(), (
        f"Page title suggests a crash: '{driver.title}'"
    )
    assert driver.current_url is not None, "Driver lost URL — page may have crashed"
    log.info(f"Page is alive — title: '{driver.title}'")


@allure.step("Assert: search input is still visible")
@then("the search input is still visible")
def step_assert_search_input_visible(search_page):
    assert search_page.is_displayed(search_page.SEARCH_INPUT, timeout=5), (
        "Search input not visible after special-character / single-char input"
    )

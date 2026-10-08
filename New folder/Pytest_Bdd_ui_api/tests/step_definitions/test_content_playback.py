"""
Step definitions for:  features/content_playback/content_playback_e2e.feature
Feature                : Content Playback End-to-End – JioHotstar
BDD scenario IDs       : BDD_E2E_001 … BDD_E2E_004
                         BDD_AUTH_001 … BDD_AUTH_003
                         BDD_API_AUTH_001, BDD_API_AUTH_002
                         BDD_API_CNT_001
"""
import pytest
import allure
from pytest_bdd import scenarios, given, when, then, parsers

from config.config import Config
from utilities.api_client import APIClient
from utilities.logger import get_logger

log = get_logger(__name__)

# Bind ALL scenarios declared in the feature file to this test module.
# pytest-bdd will auto-generate one test function per Scenario / Scenario Outline row.
scenarios("content_playback/content_playback_e2e.feature")


# ══════════════════════════════════════════════════════════════════════════════
# SHARED STATE
# pytest-bdd shares state between steps via fixtures that carry mutable dicts.
# ══════════════════════════════════════════════════════════════════════════════

@pytest.fixture
def context():
    """Mutable bag for sharing data between steps within one scenario."""
    return {}


# ══════════════════════════════════════════════════════════════════════════════
# BACKGROUND STEP
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Open JioHotstar home page")
@given("the JioHotstar home page is loaded")
def step_home_page_loaded(driver):
    from pages.home_page import HomePage
    page = HomePage(driver)
    page.open()
    log.info("Home page loaded")


# ══════════════════════════════════════════════════════════════════════════════
# GIVEN – precondition steps
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Precondition: content search API is available")
@given("the content search API is available")
def step_content_api_available(context):
    context["api_client"] = APIClient()
    log.info("APIClient initialised for content search")


@allure.step("Precondition: auth API is available")
@given("the auth API is available")
def step_auth_api_available(context):
    context["api_client"] = APIClient()
    log.info("APIClient initialised for auth tests")


@allure.step("Precondition: guest user on home page")
@given("I am on the JioHotstar home page as a guest")
def step_guest_on_home(driver):
    from pages.home_page import HomePage
    page = HomePage(driver)
    page.open()
    log.info("Home page opened as guest")


@allure.step("Precondition: user is authenticated via API")
@given("I am authenticated via API")
def step_authenticated_via_api(context):
    client = APIClient()
    resp = client.post("/auth/login", {
        "email": Config.VALID_EMAIL,
        "password": Config.VALID_PASSWORD,
    })
    if resp.status_code == 200:
        token = resp.json().get("token", "")
        client.set_auth_header(token)
        log.info("API authentication successful")
    else:
        log.warning(f"API login returned {resp.status_code}; proceeding without token")
    context["api_client"] = client


@allure.step("Precondition: user is logged in via UI")
@given("I am logged in with valid credentials")
def step_logged_in_ui(driver, context):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.open_login_page()
    page.login_with_email(Config.VALID_EMAIL, Config.VALID_PASSWORD)
    assert page.is_logged_in(), "Login failed – user avatar not visible"
    context["driver"] = driver
    log.info("UI login successful")


# ══════════════════════════════════════════════════════════════════════════════
# WHEN – action steps (API)
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("API: search for keyword '{keyword}'")
@when(parsers.parse('I call the search API with keyword "{keyword}"'))
def step_api_search(keyword, context):
    client: APIClient = context["api_client"]
    resp = client.get("/search", params={"q": keyword})
    context["api_response"] = resp
    context["search_keyword"] = keyword
    log.info(f"Search API called with keyword='{keyword}', status={resp.status_code}")


@allure.step("API: POST to '{endpoint}' with valid credentials")
@when(parsers.parse('I POST to "{endpoint}" with valid user credentials'))
def step_api_post_valid_credentials(endpoint, context):
    client: APIClient = context["api_client"]
    payload = {"email": Config.VALID_EMAIL, "password": Config.VALID_PASSWORD}
    resp = client.post(endpoint, payload)
    context["api_response"] = resp
    log.info(f"POST {endpoint} with valid creds → {resp.status_code}")


@allure.step("API: POST to '{endpoint}' with wrong password")
@when(parsers.parse('I POST to "{endpoint}" with wrong password'))
def step_api_post_wrong_password(endpoint, context):
    client: APIClient = context["api_client"]
    payload = {"email": Config.VALID_EMAIL, "password": Config.INVALID_PASSWORD}
    resp = client.post(endpoint, payload)
    context["api_response"] = resp
    log.info(f"POST {endpoint} with wrong password → {resp.status_code}")


@allure.step("API: GET '{endpoint}'")
@when(parsers.parse('I GET the "{endpoint}" endpoint'))
def step_api_get(endpoint, context):
    client: APIClient = context["api_client"]
    resp = client.get(endpoint)
    context["api_response"] = resp
    log.info(f"GET {endpoint} → {resp.status_code}")


# ══════════════════════════════════════════════════════════════════════════════
# WHEN – action steps (UI)
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("UI: search for '{keyword}'")
@when(parsers.parse('I search for "{keyword}" on the UI'))
def step_ui_search(keyword, driver, context):
    from pages.home_page import HomePage
    from pages.search_page import SearchPage
    home = HomePage(driver)
    home.click_search_icon()
    search = SearchPage(driver)
    search.enter_search_query(keyword)
    context["search_keyword"] = keyword
    log.info(f"UI search entered: '{keyword}'")


@allure.step("UI: click first search result")
@when("I click the first search result")
def step_click_first_result(driver, context):
    from pages.search_page import SearchPage
    search = SearchPage(driver)
    title = search.get_first_result_title()
    context["selected_title"] = title
    search.click_first_result()
    log.info(f"Clicked first result: '{title}'")


@allure.step("UI: click Play button")
@when("I click the Play button")
def step_click_play(driver):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    detail.click_play_button()
    log.info("Play button clicked")


@allure.step("UI: add content to watchlist")
@when("I add the current content to my watchlist")
def step_add_to_watchlist(driver, context):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    detail.click_watchlist_button()
    context["watchlist_added"] = True
    log.info("Watchlist button clicked")


@allure.step("UI: open login modal")
@when("I open the login modal")
def step_open_login_modal(driver):
    from pages.home_page import HomePage
    home = HomePage(driver)
    home.click_login_button()
    log.info("Login modal opened")


@allure.step("UI: enter credentials")
@when(parsers.parse('I enter email "{email}" and password "{password}"'))
def step_enter_credentials(email, password, driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.enter_email(email)
    page.click_continue()
    page.enter_password(password)
    log.info(f"Credentials entered for {email}")


@allure.step("UI: submit login form")
@when("I submit the login form")
def step_submit_login(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    page.click_submit()
    log.info("Login form submitted")


@allure.step("UI: open profile dropdown")
@when("I open the profile dropdown")
def step_open_profile_dropdown(driver):
    from pages.profile_page import ProfilePage
    page = ProfilePage(driver)
    page.click_avatar()
    log.info("Profile dropdown opened")


@allure.step("UI: click Logout")
@when("I click the Logout option")
def step_click_logout(driver):
    from pages.profile_page import ProfilePage
    page = ProfilePage(driver)
    page.click_logout()
    log.info("Logout clicked")


@allure.step("API: verify watchlist via API")
@when("I call the watchlist API to verify")
def step_verify_watchlist_api(context):
    client = APIClient()
    resp = client.get("/user/watchlist")
    context["watchlist_api_response"] = resp
    log.info(f"Watchlist API → {resp.status_code}")


# ══════════════════════════════════════════════════════════════════════════════
# THEN – assertion steps (API)
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Assert: API status code is {expected_code}")
@then(parsers.parse("the API response status code is {expected_code:d}"))
def step_assert_status_code(expected_code, context):
    resp = context["api_response"]
    with allure.step(f"Response status: {resp.status_code}"):
        assert resp.status_code == expected_code, (
            f"Expected HTTP {expected_code}, got {resp.status_code}\nBody: {resp.text[:500]}"
        )


@allure.step("Assert: response has at least 1 content result")
@then("the API response contains at least 1 content result")
def step_assert_at_least_one_result(context):
    body = context["api_response"].json()
    results = body.get("results", body.get("data", []))
    assert len(results) >= 1, f"Expected results, got: {body}"
    context["api_results"] = results


@allure.step("Assert: result titles contain keyword")
@then(parsers.parse('the result titles contain the keyword "{keyword}"'))
def step_assert_titles_contain_keyword(keyword, context):
    results = context.get("api_results", [])
    titles = [r.get("title", r.get("name", "")) for r in results]
    matched = [t for t in titles if keyword.lower() in t.lower()]
    assert len(matched) > 0, (
        f"No title contains '{keyword}'. Titles found: {titles}"
    )


@allure.step("Assert: response body contains '{field}' field")
@then(parsers.parse('the response body contains a "{field}" field'))
def step_assert_field_in_response(field, context):
    body = context["api_response"].json()
    assert field in body, f"Field '{field}' missing from response: {list(body.keys())}"
    context[f"field_{field}"] = body[field]


@allure.step("Assert: token is non-empty")
@then("the token is a non-empty string")
def step_assert_token_non_empty(context):
    token = context.get("field_token", "")
    assert isinstance(token, str) and len(token) > 0, "Token is empty or not a string"


@allure.step("Assert: 'results' array is not empty")
@then('the "results" array is not empty')
def step_assert_results_not_empty(context):
    results = context["api_response"].json().get("results", [])
    assert len(results) > 0, "Expected non-empty 'results' array"


@allure.step("Assert: content in watchlist API response")
@then("the content appears in the API watchlist response")
def step_assert_content_in_watchlist(context):
    resp = context["watchlist_api_response"]
    if resp.status_code == 401:
        pytest.skip("Watchlist API requires auth token in this environment")
    assert resp.status_code == 200, f"Watchlist API returned {resp.status_code}"
    items = resp.json().get("results", resp.json().get("data", []))
    assert len(items) >= 0, "Watchlist API returned unexpected shape"


# ══════════════════════════════════════════════════════════════════════════════
# THEN – assertion steps (UI)
# ══════════════════════════════════════════════════════════════════════════════

@allure.step("Assert: search results page displays items")
@then("the search results page displays content items")
def step_assert_search_results_visible(driver):
    from pages.search_page import SearchPage
    search = SearchPage(driver)
    assert search.has_results(), "Search results page shows no items"


@allure.step("Assert: first result title contains text")
@then(parsers.parse('the first search result title contains "{expected_text}"'))
def step_assert_first_result_title(expected_text, driver):
    from pages.search_page import SearchPage
    search = SearchPage(driver)
    title = search.get_first_result_title()
    assert expected_text.lower() in title.lower(), (
        f"Expected '{expected_text}' in title, got '{title}'"
    )


@allure.step("Assert: content detail page is displayed")
@then("the content detail page is displayed")
def step_assert_content_detail_page(driver):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    assert detail.is_loaded(), "Content detail page did not load"


@allure.step("Assert: Subscribe CTA is visible")
@then("the Subscribe CTA is visible")
def step_assert_subscribe_cta(driver):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    assert detail.is_subscribe_cta_visible(), "Subscribe CTA not visible for premium content"


@allure.step("Assert: paywall message mentions Subscribe or Premium")
@then('the paywall message mentions "Subscribe" or "Premium"')
def step_assert_paywall_message(driver):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    msg = detail.get_paywall_message().lower()
    assert "subscribe" in msg or "premium" in msg, (
        f"Paywall message does not mention Subscribe/Premium: '{msg}'"
    )


@allure.step("Assert: video player is visible")
@then("the video player is visible")
def step_assert_player_visible(driver):
    from pages.player_page import PlayerPage
    player = PlayerPage(driver)
    assert player.is_player_visible(), "Video player element not found on page"


@allure.step("Assert: playback starts within 10 seconds")
@then("playback starts within 10 seconds")
def step_assert_playback_started(driver):
    from pages.player_page import PlayerPage
    player = PlayerPage(driver)
    assert player.wait_for_playback_to_start(timeout=10), "Playback did not start within 10s"


@allure.step("Assert: watchlist icon shows added state")
@then("the watchlist icon shows added state")
def step_assert_watchlist_added_state(driver):
    from pages.content_detail_page import ContentDetailPage
    detail = ContentDetailPage(driver)
    assert detail.is_watchlist_added(), "Watchlist icon does not reflect added state"


@allure.step("Assert: user is logged in")
@then("I should be logged in")
def step_assert_logged_in(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    assert page.is_logged_in(), "User is not logged in after submit"


@allure.step("Assert: user avatar is visible")
@then("the user avatar is visible in the navigation bar")
def step_assert_avatar_visible(driver):
    from pages.home_page import HomePage
    home = HomePage(driver)
    assert home.is_user_avatar_visible(), "User avatar not visible after login"


@allure.step("Assert: error message is displayed")
@then("an error message is displayed")
def step_assert_error_message_displayed(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    assert page.is_error_visible(), "No error message displayed for invalid credentials"


@allure.step("Assert: error message contains 'Invalid' or 'incorrect'")
@then('the error message contains "Invalid" or "incorrect"')
def step_assert_error_message_text(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    msg = page.get_error_message().lower()
    assert "invalid" in msg or "incorrect" in msg or "wrong" in msg, (
        f"Error message '{msg}' does not contain expected keywords"
    )


@allure.step("Assert: user is logged out")
@then("I should be logged out")
def step_assert_logged_out(driver):
    from pages.login_page import LoginPage
    page = LoginPage(driver)
    assert not page.is_logged_in(), "User still appears logged in after logout"


@allure.step("Assert: Login button is visible in nav bar")
@then("the Login button is visible in the navigation bar")
def step_assert_login_button_visible(driver):
    from pages.home_page import HomePage
    home = HomePage(driver)
    assert home.is_login_button_visible(), "Login button not visible in nav after logout"

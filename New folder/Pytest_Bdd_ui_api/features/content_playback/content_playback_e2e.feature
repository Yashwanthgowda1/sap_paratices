# ─────────────────────────────────────────────────────────────────────────────
# Feature  : Content Playback – End-to-End (UI + API)
# App      : JioHotstar OTT Platform
# Owner    : QA Team
# Tags     : @e2e  @content  @player
#
# Covers:
#   • API – content search endpoint returns matching titles
#   • API – content detail endpoint returns valid metadata
#   • UI  – user can find content via search and open detail page
#   • UI  – user can initiate playback of free content
#   • UI  – premium content gate shows subscribe CTA for free user
#   • UI  – logged-in user can add content to watchlist mid-playback
# ─────────────────────────────────────────────────────────────────────────────

Feature: Content Playback End-to-End – JioHotstar
  As a JioHotstar viewer
  I want to search for content and play it back
  So that I can watch movies, series, and live sports without friction

  Background:
    Given the JioHotstar home page is loaded

  # ─── BDD_E2E_001 ─────────────────────────────────────────────────────────────
  @BDD_E2E_001 @sanity @smoke @e2e @api @ui
  Scenario: BDD_E2E_001 | [SANITY] Search returns API results and UI renders matching titles
    Given the content search API is available
    When I call the search API with keyword "Avengers"
    Then the API response status code is 200
    And the API response contains at least 1 content result
    And the result titles contain the keyword "Avengers"
    When I search for "Avengers" on the UI
    Then the search results page displays content items
    And the first search result title contains "Avengers"

  # ─── BDD_E2E_002 ─────────────────────────────────────────────────────────────
  @BDD_E2E_002 @smoke @e2e @subscription @negative @ui
  Scenario: BDD_E2E_002 | [SMOKE] Free user sees Subscribe CTA when opening premium content
    Given I am on the JioHotstar home page as a guest
    When I search for "Aarya" on the UI
    And I click the first search result
    Then the content detail page is displayed
    When I click the Play button
    Then the Subscribe CTA is visible
    And the paywall message mentions "Subscribe" or "Premium"

  # ─── BDD_E2E_003 ─────────────────────────────────────────────────────────────
  @BDD_E2E_003 @regression @e2e @auth @watchlist @api @ui
  Scenario: BDD_E2E_003 | [REGRESSION] Logged-in user can search, play free content, and add to watchlist
    Given I am logged in with valid credentials
    When I search for "Avengers" on the UI
    And I click the first search result
    Then the content detail page is displayed
    When I click the Play button
    Then the video player is visible
    And playback starts within 10 seconds
    When I add the current content to my watchlist
    Then the watchlist icon shows added state
    When I call the watchlist API to verify
    Then the content appears in the API watchlist response

  # ─── BDD_AUTH_001 ────────────────────────────────────────────────────────────
  @BDD_AUTH_001 @sanity @smoke @auth @ui
  Scenario: BDD_AUTH_001 | [SANITY] User can log in with valid email and password
    Given I am on the JioHotstar home page as a guest
    When I open the login modal
    And I enter email "testuser@example.com" and password "Test@1234"
    And I submit the login form
    Then I should be logged in
    And the user avatar is visible in the navigation bar

  # ─── BDD_AUTH_002 ────────────────────────────────────────────────────────────
  @BDD_AUTH_002 @smoke @auth @negative @ui
  Scenario: BDD_AUTH_002 | [SMOKE] Invalid credentials show an error message
    Given I am on the JioHotstar home page as a guest
    When I open the login modal
    And I enter email "wrong@example.com" and password "WrongPass999"
    And I submit the login form
    Then an error message is displayed
    And the error message contains "Invalid" or "incorrect"

  # ─── BDD_AUTH_003 ────────────────────────────────────────────────────────────
  @BDD_AUTH_003 @regression @auth @ui
  Scenario: BDD_AUTH_003 | [REGRESSION] Logged-in user can log out successfully
    Given I am logged in with valid credentials
    When I open the profile dropdown
    And I click the Logout option
    Then I should be logged out
    And the Login button is visible in the navigation bar

  # ─── BDD_API_AUTH_001 ────────────────────────────────────────────────────────
  @BDD_API_AUTH_001 @sanity @smoke @api @auth
  Scenario: BDD_API_AUTH_001 | [SANITY] POST /auth/login returns 200 with a token for valid credentials
    Given the auth API is available
    When I POST to "/auth/login" with valid user credentials
    Then the API response status code is 200
    And the response body contains a "token" field
    And the token is a non-empty string

  # ─── BDD_API_AUTH_002 ────────────────────────────────────────────────────────
  @BDD_API_AUTH_002 @smoke @api @auth @negative
  Scenario: BDD_API_AUTH_002 | [SMOKE] POST /auth/login returns 401 for wrong password
    Given the auth API is available
    When I POST to "/auth/login" with wrong password
    Then the API response status code is 401

  # ─── BDD_API_CNT_001 ─────────────────────────────────────────────────────────
  @BDD_API_CNT_001 @sanity @api @content
  Scenario: BDD_API_CNT_001 | [SANITY] GET /content returns 200 with a non-empty content array
    Given I am authenticated via API
    When I GET the "/content" endpoint
    Then the API response status code is 200
    And the response body contains a "results" array
    And the "results" array is not empty

  # ─── Parametrised search ─────────────────────────────────────────────────────
  @BDD_E2E_004 @regression @e2e @search @ui
  Scenario Outline: BDD_E2E_004 | [REGRESSION] Parametrised search finds expected content on UI
    Given the JioHotstar home page is loaded
    When I search for "<keyword>" on the UI
    Then the search results page displays content items
    And the first search result title contains "<expected_text>"

    Examples:
      | keyword   | expected_text |
      | Avengers  | Avengers      |
      | Animal    | Animal        |
      | Cricket   | Cricket       |
      | Aarya     | Aarya         |

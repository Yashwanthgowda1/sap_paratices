# ─────────────────────────────────────────────────────────────────────────────
# Feature  : Search
# App      : JioHotstar OTT Platform
# Owner    : QA Team
# Tags     : @search @ui
#
# Covers:
#   BDD_SRCH_001  Valid keyword returns results
#   BDD_SRCH_002  Unknown keyword shows no-results message
#   BDD_SRCH_003  Each result title is relevant to the keyword
#   BDD_SRCH_004  Clicking first result opens content detail page
#   BDD_SRCH_005  Clearing search input resets results
#   BDD_SRCH_006  Special characters do not crash the page
#   BDD_SRCH_007  Single character search is stable
#   BDD_SRCH_008  Parametrised – multiple valid keywords (Scenario Outline)
# ─────────────────────────────────────────────────────────────────────────────

Feature: Search – JioHotstar
  As a JioHotstar viewer
  I want to search for content by keyword
  So that I can quickly find movies, series, and live sports

  Background:
    Given the JioHotstar home page is open
    And the search icon is clicked

  # ─── BDD_SRCH_001 ──────────────────────────────────────────────────────────
  @BDD_SRCH_001 @sanity @smoke @search @ui
  Scenario: BDD_SRCH_001 | [SANITY] Valid keyword returns search results
    When I type "Avengers" in the search box
    Then the search results page is displayed
    And at least 1 result is shown

  # ─── BDD_SRCH_002 ──────────────────────────────────────────────────────────
  @BDD_SRCH_002 @smoke @search @negative @ui
  Scenario: BDD_SRCH_002 | [SMOKE] Unknown keyword shows no-results message
    When I type "xyzxyzxyz123notexist" in the search box
    Then the no-results message is displayed
    And 0 result items are shown

  # ─── BDD_SRCH_003 ──────────────────────────────────────────────────────────
  @BDD_SRCH_003 @regression @search @ui
  Scenario: BDD_SRCH_003 | [REGRESSION] All result titles are relevant to the keyword
    When I type "Avengers" in the search box
    Then the search results page is displayed
    And all result titles contain the keyword "Avengers"

  # ─── BDD_SRCH_004 ──────────────────────────────────────────────────────────
  @BDD_SRCH_004 @smoke @search @content @ui
  Scenario: BDD_SRCH_004 | [SMOKE] Clicking first result opens content detail page
    When I type "Avengers" in the search box
    Then the search results page is displayed
    When I click the first result from search
    Then the content detail page is loaded

  # ─── BDD_SRCH_005 ──────────────────────────────────────────────────────────
  @BDD_SRCH_005 @regression @search @ui
  Scenario: BDD_SRCH_005 | [REGRESSION] Clearing the search input resets results
    When I type "Avengers" in the search box
    Then the search results page is displayed
    When I clear the search input
    Then the search results are cleared or the search input is empty

  # ─── BDD_SRCH_006 ──────────────────────────────────────────────────────────
  @BDD_SRCH_006 @regression @search @negative @ui
  Scenario: BDD_SRCH_006 | [REGRESSION] Special characters do not crash the page
    When I type "@#$%^&*" in the search box
    Then the page does not crash
    And the search input is still visible

  # ─── BDD_SRCH_007 ──────────────────────────────────────────────────────────
  @BDD_SRCH_007 @regression @search @ui
  Scenario: BDD_SRCH_007 | [REGRESSION] Single character search is stable
    When I type "A" in the search box
    Then the page does not crash
    And the search input is still visible

  # ─── BDD_SRCH_008 ──────────────────────────────────────────────────────────
  @BDD_SRCH_008 @regression @search @ui
  Scenario Outline: BDD_SRCH_008 | [REGRESSION] Parametrised search finds results for valid keywords
    When I type "<keyword>" in the search box
    Then the search results page is displayed
    And the first result title contains "<expected>"

    Examples:
      | keyword   | expected  |
      | Avengers  | Avengers  |
      | Animal    | Animal    |
      | Cricket   | Cricket   |
      | Aarya     | Aarya     |

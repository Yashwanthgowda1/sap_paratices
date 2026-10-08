Feature: JioHotstar Search

  Background:
    Given user launches the JioHotstar application
    And user is logged in
    And user is on the Home page

  @smoke @regression
  Scenario: Search for a valid movie
    When user taps on the Search icon
    And user types "RRR" in the search bar
    Then user should see search results for "RRR"
    And movie poster should be visible in results

  @regression
  Scenario: Search for a TV show
    When user taps on the Search icon
    And user types "Bigg Boss" in the search bar
    Then user should see search results for "Bigg Boss"
    And content type "TV Show" should be displayed

  @regression
  Scenario: Search with invalid keyword
    When user taps on the Search icon
    And user types "xyzabc123" in the search bar
    Then user should see message "No results found"

  @regression
  Scenario: Search suggestions appear while typing
    When user taps on the Search icon
    And user types "Sac" in the search bar
    Then auto suggestions should be displayed
    And suggestions should contain "Sachin"

  @smoke @regression
  Scenario: Clear search text
    When user taps on the Search icon
    And user types "KGF" in the search bar
    And user taps the clear icon
    Then search bar should be empty
    And trending content should be visible

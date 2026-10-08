Feature: JioHotstar Video Playback

  Background:
    Given user launches the JioHotstar application
    And user is logged in with premium account
    And user is on the Home page

  @smoke @regression
  Scenario: Play a movie successfully
    When user selects movie "KGF Chapter 2"
    And user taps on "Play" button
    Then video should start playing within 5 seconds
    And playback controls should be visible

  @smoke @regression
  Scenario: Pause and Resume video
    When user selects movie "KGF Chapter 2"
    And user taps on "Play" button
    And video is playing
    When user taps on "Pause" button
    Then video should be paused
    When user taps on "Play" button again
    Then video should resume from the same position

  @regression
  Scenario: Change video quality
    When user selects movie "KGF Chapter 2"
    And user taps on "Play" button
    And video is playing
    When user taps on Settings icon
    And user selects quality "1080p"
    Then video should play in "1080p" quality

  @regression
  Scenario: Enable subtitles during playback
    When user selects movie "RRR"
    And user taps on "Play" button
    And video is playing
    When user taps on Subtitle icon
    And user selects language "English"
    Then subtitles should be displayed on screen

  @regression
  Scenario: Non premium user tries to play premium content
    Given user is logged in with free account
    When user selects premium movie "Pathaan"
    And user taps on "Play" button
    Then subscription popup should be displayed
    And "Subscribe Now" button should be visible

  @regression
  Scenario Outline: Playback in different languages
    When user selects content "<title>"
    And user taps on "Play" button
    Then video should start playing in "<language>"

    Examples:
      | title        | language  |
      | KGF Chapter 2 | Kannada  |
      | RRR           | Telugu   |
      | Pathaan       | Hindi    |

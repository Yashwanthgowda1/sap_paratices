Feature: JioHotstar Login

  Background:
    Given user launches the JioHotstar application
    And user is on the Login page

  @smoke @regression
  Scenario: Successful login with valid credentials
    When user enters mobile number "9876543210"
    And user enters OTP "123456"
    And user taps on "Verify" button
    Then user should be navigated to the Home page
    And user profile icon should be visible

  @smoke @regression
  Scenario: Login with invalid OTP
    When user enters mobile number "9876543210"
    And user enters OTP "000000"
    And user taps on "Verify" button
    Then user should see error message "Invalid OTP. Please try again."
    And user should remain on the Login page

  @regression
  Scenario: Login with unregistered mobile number
    When user enters mobile number "0000000000"
    And user taps on "Get OTP" button
    Then user should see error message "Mobile number not registered"

  @regression
  Scenario: Resend OTP functionality
    When user enters mobile number "9876543210"
    And user taps on "Get OTP" button
    And user taps on "Resend OTP" link
    Then user should see message "OTP sent successfully"

  @regression
  Scenario: Guest user browsing without login
    When user taps on "Continue as Guest" button
    Then user should be navigated to the Home page
    And subscription banner should be displayed

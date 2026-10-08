Feature: JioHotstar Subscription

  Background:
    Given user launches the JioHotstar application
    And user is logged in with free account

  @smoke @regression
  Scenario: View available subscription plans
    When user taps on "Subscribe" button
    Then subscription plans page should be displayed
    And below plans should be visible
      | Mobile  |
      | Super   |
      | Premium |

  @regression
  Scenario: Select Monthly plan and proceed to payment
    When user taps on "Subscribe" button
    And user selects "Super" plan
    And user selects "Monthly" billing cycle
    And user taps on "Proceed to Pay" button
    Then payment options page should be displayed
    And price should show "299"

  @regression
  Scenario: Apply valid coupon code
    When user taps on "Subscribe" button
    And user selects "Premium" plan
    And user taps on "Have a coupon?" link
    And user enters coupon code "HOTSTAR50"
    And user taps on "Apply" button
    Then discount should be applied
    And updated price should be displayed

  @regression
  Scenario: Apply invalid coupon code
    When user taps on "Subscribe" button
    And user selects "Premium" plan
    And user taps on "Have a coupon?" link
    And user enters coupon code "INVALID123"
    And user taps on "Apply" button
    Then user should see error "Invalid or expired coupon code"

  @regression
  Scenario: Verify active subscription details
    Given user is logged in with premium account
    When user navigates to "My Account"
    And user taps on "Subscription" tab
    Then current plan name should be displayed
    And plan expiry date should be visible
    And "Renew" button should be displayed

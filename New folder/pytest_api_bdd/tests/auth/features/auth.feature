Feature: Authentication
  As an API consumer
  I want to generate a bearer token
  So that I can make authenticated requests

  Scenario: Valid credentials return a token
    Given the auth endpoint is available
    When I send a POST to "/auth" with valid credentials
    Then the response status code should be 200
    And the response body should contain a "token"

  Scenario: Invalid password returns bad credentials
    Given the auth endpoint is available
    When I send a POST to "/auth" with invalid password
    Then the response status code should be 200
    And the response body should contain reason "Bad credentials"

  Scenario: Empty credentials are rejected using DataTable
    Given the auth endpoint is available
    When I send login requests for the following credentials
      | username | password    |
      |          | password123 |
      | admin    |             |
      |          |             |
    Then all login attempts should be rejected

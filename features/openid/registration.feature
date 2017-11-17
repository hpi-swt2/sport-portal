Feature: OpenID Registration
  In order to simplify my login process
  As a unregistered user with an OpenID Account
  I want to sign up with my OpenID Account

  Scenario: Sign in attempt
    Given a new user
    And an unlinked OpenID account
    When the account is used to sign in
    Then the page should have inputs for missing user data
    And the inputs should be filled with the available account data

  Scenario: Sign up
    Given a new user
    And an unlinked OpenID account
    When the account is used to sign in
    And the user enters his data
    Then the user should be linked with the account

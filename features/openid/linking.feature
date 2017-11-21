Feature: OpenID Linking
  In order to simplify my login process
  As a registered user with an OpenID account
  I want to connect my platform account with my OpenID account

  Scenario: OpenID Linking
    Given a user
    And the user is logged in
    And an unlinked OpenID account
    And the account is used for authentication
    When he views his account settings
    And he clicks 'Connect with OpenID'
    Then the user should be linked with the account

  Scenario: OpenID Unlinking
    Given a user with a linked OpenID account
    And the user is logged in
    When he views his account settings
    And he clicks 'Disconnect from OpenID'
    Then the user should not be linked with any account

  Scenario: OpenID Sign in
    Given a user with a linked OpenID account
    When the account is used to sign in
    Then the sign in should have been successful

  Scenario: Unique OpenID
    Given a user with a linked OpenID account
    And a user John
    And John is logged in
    And the account is used for authentication
    When he views his account settings
    And he clicks 'Connect with OpenID'
    Then John should not be linked with any account

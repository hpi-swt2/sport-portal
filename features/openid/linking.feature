Feature: OpenID Linking
  In order to simplify my login process
  As a registered user with an OpenID account
  I want to connect my platform account with my OpenID account

  Scenario: OpenID Link button
    Given a user
    And the user is logged in
    When the user views his account settings
    Then there should be a 'Connect with OpenID' button

  Scenario: OpenID Unlink button
    Given a user with a linked OpenID account
    And the user is logged in
    When the user views his account settings
    Then there should be a 'Disconnect from OpenID' button

  Scenario: OpenID Linking
    Given a user
    And the user is logged in
    And an unlinked OpenID account
    And the account is used for authentication
    When the user views his account settings
    And he clicks 'Connect with OpenID'
    Then the user should be linked with the account

  Scenario: OpenID Unlinking
    Given a user with a linked OpenID account
    When the user views his account settings
    And he clicks 'Disconnect from OpenID'
    Then the user should not be linked with any account

  Scenario: OpenID Sign in
    Given a user with a linked OpenID account
    When the account is used to sign in
    Then the sign in should have been successful

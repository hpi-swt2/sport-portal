Feature: OpenID Linking
  In order to simplify my login process
  As a registered user with an OpenID account
  I want to connect my platform account with my OpenID account

  Scenario: OpenID Link button
    Given a User
    When the user views his account settings
    Then there should be a 'Connect with OpenID' button

  Scenario: OpenID Unlink button
    Given a User with a linked OpenID account
    When the user views his account settings
    Then there should be a 'Disconnect from OpenID' button

  Scenario: OpenID Linking
    Given a User
    And an unlinked OpenID account
    When the user views his account settings
    And links his OpenID account
    Then the user should be linked with the account

  Scenario: OpenID Unlinking
    Given a User with a linked OpenID account
    When the user views his account settings
    And he clicks on 'Disconnect from OpenID'
    Then the user should not be linked with the account

  Scenario: OpenID Sign in
    Given a User with a linked OpenID account
    When the account is used to sign in
    Then the user should be signed in

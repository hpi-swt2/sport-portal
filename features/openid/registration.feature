Feature: OpenID Registration
  In order to simplify my login process
  As an unregistered user with an OpenID Account
  I want to sign up with my OpenID Account

  Scenario: Sign up attempt without name
    Given a new user
    And an unlinked OpenID account with email 'test@test.com'
    When the account is used to sign in
    Then the 'E-Mail' input should already be filled with 'test@test.com'
    And there should be an input 'Vorname'
    And there should be an input 'Nachname'
    And there should not be an input 'Passwort'

  Scenario: Sign up attempt with name
    Given a new user
    And an unlinked OpenID account with email 'test@test.com', first name 'Horst' and last name 'Peter'
    When the account is used to sign in
    Then the new user should be linked with the account
    And the new user's first name should be 'Horst'
    And the new user's last name should be 'Peter'

  Scenario: Sign up
    Given a new user
    And an unlinked OpenID account
    When the account is used to sign in
    And the user enters his name
    And the user submits the form
    Then the new user should be linked with the account

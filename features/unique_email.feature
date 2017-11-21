Feature: Unique Emails
In order to identify my users via e-mail addresses (for example during login processes)
As an admin
I want to have only one user per e-mail address

  Scenario: Sign up with existing email address
    Given a user a with email test@test.com
    And a new user b with email test@test.com
    When b tries to sign up
    Then b should not be able to sign-up

  Scenario: email addresses should be case insensitive
    Given a user a with email TEST@TesT.cOm
    And a new user b with email test@test.com
    When b tries to sign up
    Then b should not be able to sign up

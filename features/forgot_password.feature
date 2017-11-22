Feature: A working "Forgot-Password" mechanism

  Background:
    Given a registered User Ulf

  Scenario: A User starts the "Forgot-Password" Routine
    When Ulf visits the password recovery page
    And Ulf inserts his email address
    And submits
    Then He gets an Email with a recovery link

  Scenario: A User restores his password
    When Ulf clicks a recovery link
    And enters a new password
    And tries to log in with the new password
    Then Ulf is logged in
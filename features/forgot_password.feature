Feature:
  A working "Forgot-Password" mechanism

  Scenario: A User starts the "Forgot-Password" Routine
    Given a new user ulf with email ulf@ulf.de
    When ulf visits the password recovery page
    And ulf inserts his email address
    And submits
    Then ulf gets an Email with a recovery link

  Scenario: A User restores his password
    Given a new user ulf with email ulf@ulf.de
    When ulf clicks a recovery link
    And ulf enters a new password
    And ulf tries to log in with his new password
    Then ulf is logged in
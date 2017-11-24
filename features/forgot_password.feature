Feature:
  A working "Forgot-Password" mechanism

  Scenario: A User starts the "Forgot-Password" Routine
    Given a new user ulf with email ulf@ulf.de
    And ulf is stored in the database

    When ulf visits the password recovery page
    And ulf inserts his email address
    And submits
    Then ulf gets an Email with a recovery link

    When ulf clicks the recovery link
    And ulf enters a new password
    And he logs out
    Then ulf is able to log in again
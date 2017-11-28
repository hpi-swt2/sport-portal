Feature:
  A working "Forgot-Password" mechanism

  Scenario: A User starts the "Forgot-Password" Routine
    Given a user ulf with email ulf@ulf.de
    And ulf is stored in the database

    When he visits the password recovery page
    And ulf inserts his email address
    And submits
    Then ulf gets an Email with a recovery link

    When he clicks the recovery link
    And he enters a new password
    And he logs out
    Then ulf is able to log in again
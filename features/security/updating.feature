Feature: Account editing
  As a user
  In order to increase my comfort
  I want to not have to enter my password on simple changes


  Scenario: simple changes
    Given a user
    And the user is logged in
    When he views his account settings
    And he enters the first name 'Frankenstein'
    And the user submits the form
    Then his first name should be 'Frankenstein'

  Scenario: dangerous changes without password
    Given a user
    And the user is logged in
    When he views his account settings
    And he enters the email 'email@email.email'
    And the user submits the form
    Then his email should not have changed

  Scenario: dangerous changes with password
    Given a user
    And the user is logged in
    When he views his account settings
    And he enters the email 'email@email.email'
    And he enters his current password
    And the user submits the form
    And he clicks the link in the email he just received at his new mail account
    Then his email should be 'email@email.email'

  Scenario: dangerous changes with password still need email verification
    Given a user
    And the user is logged in
    When he views his account settings
    And he enters the email 'email@email.email'
    And he enters his current password
    And the user submits the form
    Then his email should not have changed


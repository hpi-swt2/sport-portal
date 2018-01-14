Feature: Account deletion
  As a user
  In order to increase account security
  I want to have to enter my password to confirm deleting my account

  Scenario: Correct password
    Given a user
    And the user is logged in
    When the user wants to delete his account
    And he enters his password
    And the user submits the form
    Then the user should be deleted

  Scenario: Incorrect password
    Given a user
    And the user is logged in
    When the user wants to delete his account
    And he enters a wrong password
    And the user submits the form
    Then the user should not be deleted


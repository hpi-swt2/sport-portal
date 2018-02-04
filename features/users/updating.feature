Feature: Account updates

  Scenario: Return to profile page on save
    Given a user
    And the user is logged in
    When he views his account settings
    And he enters the first name 'Frankenstein'
    And the user submits the form
    Then he should see his profile page

Feature: Working-"back" buttons
  As a user of the platform
  I want to have working "back" buttons
  In order to navigate through the platform easily

  Scenario: Visit show overview page
    Given a user
    And the user is logged in
    And a tournament 'MyTournament' with 4 teams
    Then there should be a back button on all pages except the start page
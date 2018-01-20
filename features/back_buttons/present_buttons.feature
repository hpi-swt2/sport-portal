Feature: Working-"back" buttons
  As a user of the platform
  I want to have working "back" buttons
  In order to navigate through the platform easily

  Scenario: Visit show overview page
    Given a user
    And the user is logged in
    And a tournament 'MyTournament' with 4 teams
    And a tournament 'Tourney2' with 2 users
    And the Spielplan page for 'Tourney2' is visited
    Then there should be a back button on all pages except the start page
Feature: Working-"back" buttons
  As a user of the platform
  I want to have working "back" buttons
  In order to navigate through the platform easily

  Scenario: Visit all pages
    Given a user
    And the user is logged in
    And a tournament 'MyTournament' with 4 teams
    And a tournament 'Tourney2' with 2 users
    # Ensure Schedule is generated
    When the Spielplan page for 'MyTournament' is visited
    # In case of errors, adjust this step
    Given all relevant routes
    Then there should be a back button on all relevant pages

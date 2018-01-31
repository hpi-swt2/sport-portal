Feature: Tournament Overview Page
  As a tournament participant
  In order to see how far each team came / its status
  I want to have a page that shows the progress/history of the tournament

  Scenario: Tournament overview page should have a table with appropriate column names
    Given a tournament t.
    When the tournament overview page for t is visited
    Then there should be a table
    And the table should have a column named 'events.overview.teamColumn'
    And the table should have a column named 'events.overview.standingColumn'

  Scenario: Tournament overview page should have a table with the right amount of rows
    Given a tournament t with 10 teams
    When the tournament overview page for t is visited
    Then there should be a table
    And the table should have 10 rows

  Scenario: Tournament overview page should display the right standings
    Given a tournament t with 6 teams

    When the tournament overview page for t is visited
    Then the standing of the home team of match Viertelfinale 1 is 'Im Viertelfinalspiel 1'
    And the standing of the away team of match Viertelfinale 1 is 'Im Viertelfinalspiel 1'
    And the standing of the home team of match Viertelfinale 2 is 'Im Viertelfinalspiel 2'

    And the Spielplan page for t is visited
    And the results for match Viertelfinale 1 (6 : 7) got inserted

    When the tournament overview page for t is visited
    Then the standing of the home team of match Viertelfinale 1 is 'Im Viertelfinalspiel 1 ausgeschieden'
    And the standing of the away team of match Viertelfinale 1 is 'Im Halbfinalspiel 2'
    And the standing of the home team of match Viertelfinale 2 is 'Im Viertelfinalspiel 2'

  Scenario: Tournament overview page should link to matches
    Given a tournament t with 6 teams

    When the tournament overview page for t is visited
    Then the standing of the home team of match Viertelfinale 1 links to Viertelfinale 1
    And the standing of the away team of match Viertelfinale 1 links to Viertelfinale 1
    And the standing of the home team of match Viertelfinale 2 links to Viertelfinale 2

  Scenario: Tournament overview page should link to opponents
    Given a tournament t with 5 teams

    When the tournament overview page for t is visited
    Then the opponent of the home team of match Viertelfinale 1 links to the away team of match Viertelfinale 1
    And the opponent of the away team of match Viertelfinale 1 links to the home team of match Viertelfinale 1
    And the home team of match Halbfinale 2 links to no opponent

    When the Spielplan page for t is visited
    And the results for match Viertelfinale 1 (6 : 7) got inserted
    Then the opponent of the home team of match Halbfinale 2 links to the away team of match Halbfinale 2
    And the opponent of the away team of match Halbfinale 2 links to the home team of match Halbfinale 2

Feature: Spielplan progression for tournament
  As a tournament organizer
  in order to organise a tournament
  I want to have a complete Spielplan for my ko-tournament event

  Match indices:

    3
   / \
  1   2

  Scenario: Spielplan updates according to the inserted results
    Given a tournament t with 4 teams
    And the Spielplan page for t is visited

    When the results for match Halbfinale 1 (7 : 6) got inserted
    Then the home team of match Halbfinale 1 is in match Finale 1
    And the away team of match Halbfinale 1 isn't in match Finale 1

    When the results for match Halbfinale 2 (3 : 4) got inserted
    Then the away team of match Halbfinale 2 is in match Finale 1
    And the home team of match Halbfinale 2 isn't in match Finale 1

    When the results for match Finale 1 (1 : 0) got inserted
    Then the standing of the home team of match Halbfinale 1 is 'Erster Platz'
    Then the standing of the away team of match Halbfinale 2 is 'Zweiter Platz'

    Then the standing of the home team of match Halbfinale 2 is 'Im Spiel um Platz 3'
    Then the standing of the away team of match Halbfinale 1 is 'Im Spiel um Platz 3'

    When the Spielplan page for t is visited
    And the results for match Spiel um Platz 3 1 (3 : 6) got inserted
    Then the standing of the home team of match Halbfinale 2 is 'Dritter Platz'
    Then the standing of the away team of match Halbfinale 1 is 'Vierter Platz'

  Scenario: only three teams
    Given a tournament t with 3 teams
    And the Spielplan page for t is visited

    When the results for match Halbfinale 1 (7 : 6) got inserted
    Then the home team of match Halbfinale 1 is in match Finale 1
    And the away team of match Halbfinale 1 isn't in match Finale 1

    Then the standing of the away team of match Halbfinale 1 is 'Im Halbfinalspiel 1 ausgeschieden'

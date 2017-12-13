Feature: Spielplan progression for tournament
  As a tournament organizer
  in order to organise a tournament
  I want to have a complete Spielplan for my ko-tournament event

  Match indices:

       7
      / \
     /   \
    5     6
   / \   / \
  1   2 3   4

  Background:
    Given a tournament t with 8 teams
    And the Spielplan page for t is visited

  Scenario: Spielplan updates according to the inserted results
    When the results for match 1 (66 : 7) got inserted
    Then the home team of match 1 is in match 5
    And the away team of match 1 isn't in match 5

    When the results for match 2 (3 : 4) got inserted
    Then the away team of match 2 is in match 5
    And the home team of match 2 isn't in match 5

    When the results for match 5 (1 : 0) got inserted
    Then the home team of match 5 is in match 7
    And the home team of match 1 is in match 7
    And the away team of match 5 isn't in match 7

    #Now it gets interesting: We change, what happened in match 1
    When the results for match 1 (6 : 7) got inserted
    Then the away team of match 1 is in match 5
    And the away team of match 1 is in match 7
    And the home team of match 1 isn't in match 5
    And the home team of match 1 isn't in match 7

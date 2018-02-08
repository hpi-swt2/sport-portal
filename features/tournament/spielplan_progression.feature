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
    Given a logged in admin
    Given a tournament t with 8 teams
    And the Spielplan page for t is visited

  Scenario: Spielplan updates according to the inserted results
    When the results for match Viertelfinale 1 (66 : 7) got inserted
    Then the home team of match Viertelfinale 1 is in match Halbfinale 1
    And the away team of match Viertelfinale 1 isn't in match Halbfinale 1

    When the results for match Viertelfinale 2 (3 : 4) got inserted
    Then the away team of match Viertelfinale 2 is in match Halbfinale 1
    And the home team of match Viertelfinale 2 isn't in match Halbfinale 1

    When the results for match Halbfinale 1 (1 : 0) got inserted
    Then the home team of match Halbfinale 1 is in match Finale 1
    And the home team of match Viertelfinale 1 is in match Finale 1
    And the away team of match Halbfinale 1 isn't in match Finale 1

    #Now it gets interesting: We change, what happened in match 1
    When the results for match Viertelfinale 1 (6 : 7) got inserted
    Then the away team of match Viertelfinale 1 is in match Halbfinale 1
    And the away team of match Viertelfinale 1 is in match Finale 1
    And the home team of match Viertelfinale 1 isn't in match Halbfinale 1
    And the home team of match Viertelfinale 1 isn't in match Finale 1

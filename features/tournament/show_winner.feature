Feature: Show Tournament winners
  As a tournament winner
  I want to be shown
  In order to let everyone know that my team is awesome

  Scenario: a small Tournament gets finished
    Given a tournament t with 4 teams
    And the Spielplan page for t is visited
    And the results for match Halbfinale 1 (3 : 4) got inserted
    And the results for match Halbfinale 2 (7 : 6) got inserted
    And the results for match Finale 1 (3 : 4) got inserted
    When the tournament's page is visited
    Then the first place of the tournament is the home team of Halbfinale 2
    And the second place of the tournament is the away team of Halbfinale 1

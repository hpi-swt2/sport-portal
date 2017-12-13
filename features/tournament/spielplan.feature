Feature: Spielplan for tournament
  As a tournament organizer
  in order to organise a tournament
  I want to have a complete Spielplan for my ko-tournament event

  Background:
    Given a tournament t with 23 teams

  Scenario: Spielplan should be linked from tournament overview page
    When the event page for t is visited
    Then there should be a 'zum Spielplan' link
    And it should link to tournament Spielplan for t

  Scenario: Spielplan should have several rounds for ko tournament
    When the Spielplan page for t is visited
    Then there should be several rounds
    And there should be exactly 22 matches and 5 rounds
    And the texts Vorrunde 1, Achtelfinale, Viertelfinale, Halbfinale, Finale are there.

  Scenario: Spielplan should update winner teams continuously
    When the Spielplan page for t is visited
    And the results for match 1 (30 : 7) got inserted
    Then the home team of match 1 comes to the next round

    When the results for match 1 (3 : 7) got inserted
    Then the away team of match 1 comes to the next round
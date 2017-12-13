Feature: Spielplan for tournament
  As a tournament organizer
  in order to organise a torunament
  I want to have a complete Spielplan for my ko-tournament event

  Background:
    Given a tournament t with 16 teams

  Scenario: Spielplan should be linked from tournament overview page
    When the event page for t is visited
    Then there should be a 'zum Spielplan' link
    And it should link to tournament Spielplan for t

  Scenario: Spielplan should have several rounds for ko tournament
    When the Spielplan page for t is visited
    Then there should be several rounds
    And there should be exactly 15 matches and 4 rounds
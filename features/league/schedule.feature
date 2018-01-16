Feature: Schedule for league
  As a league organizer
  in order to organize a league
  I want to have a complete schedule for my round-robin event

  Background:
    Given a league l with 18 teams

  Scenario: schedule should be linked from league overview page
    When the league page for l is visited
    Then there should be a 'zum Spielplan' link
    And it should link to league schedule for l


  Scenario: schedule should use gamedayduration to calculate gamedays
    When the schedule page for l is visited
    Then there should be gameday dates
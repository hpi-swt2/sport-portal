Feature: Delete Events
  As league/tournament organizer
  I want to be able to reschedule(change dates) of my playing days
  In Order to let the participants play whenever they have time to do so.

  Background
    Given an Event e
    And a User o who is Organizer of e
    And the joining phase of e is finished, so the playing schedule has been calculated

  Scenario: change dates for gamedays
    When visiting the game schedule
    Then o should be able to enter start and end date for each gameday
    And the change should be saved

  Scenario: Only organizer can change dates

    When visiting the game schedule
    Then o should be able to change the dates of the game days
    And user x who is not organizer should not be able to do so
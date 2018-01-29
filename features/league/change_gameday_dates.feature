Feature: Delete Events
  As league/tournament organizer
  I want to be able to reschedule(change dates) of my playing days
  In Order to let the participants play whenever they have time to do so.

  Background:
    Given a league l with 18 teams
    And a User o who is Organizer of l

  Scenario: schedule should be linked from league overview page
    When the schedule page for l is visited
    Then o should be able to enter start and end date for each gameday
    And the change should be saved

  Scenario: Only organizer can change dates
    When the schedule page for l is visited
    Then o should be able to change the dates of the game days
    And user x who is not organizer should not be able to do so
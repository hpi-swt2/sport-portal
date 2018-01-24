Feature: Delete Events
  As organizer of an event or admin,
  I want to be able to delete an event
  In order to conclude an event.

  As participant of an event,
  I dont want events to be deleted
  I order not to lose match results

  Scenario: normal user should not be able to delete an event any time
    Given any event e
    And a user u
    And u is not admin
    And u is not organizer of e
    Then u should not be able to delete the event any time

  Scenario: Admin and organizer can delete event that has not yet started
    Given an event that has not started yet
    Then the admin should be able to delete it
    And the organizer should be able to delete it

  Scenario: Admin can delete event any time, organizer does not
    Given an event that has started
    Then the admin should be able to delete it
    And the organizer should not be able to delete it



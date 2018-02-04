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
    Then u should not be able to delete the event e at any time

  Scenario: Admin and organizer can delete event that has not yet started
    Given an event e that has not started yet
    Then admin a should be able to delete e
    And user u who is an organizer of e should be able to delete it

  Scenario: Admin can delete event any time, organizer does not
    Given an event e that has started
    Then admin a should be able to delete e
    And user u who is an organizer of e should not be able to delete it



Feature: Archive Events
  As organizer of an event,
  I want to be able to end an event
  In order to conclude an event.

  Background:
    Given I am on an event page
    And I am organizer of this event or I am admin of the application

  Scenario: Organizer or admin can not archive event prior to event start
    Given the event e has not started yet
    And I am organizer of the event e or admin
    Then I should not be able to archive it

  Scenario: Organizer or admin can archive event after event start
    Given the event e has started
    And I am organizer of the event e or admin
    Then I should be able to archive it

  Scenario: Archived event is not editable
    Given an archived event
    Then the event attributes should not be editable
    And the match attributes should not be editable
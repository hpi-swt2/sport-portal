Feature: Detailed event page
  As user of the platform
  I want to see all event concerning details on a page
  In order to inform myself about a specific event

  Scenario: Tournament
    Given a tournament
    When the tournament's page is visited
    Then the page header should show 'Tournament'
    And the page should show 'Team'

  Scenario: League
    Given a league with gamemode round_robin
    When the league's page is visited
    Then the page header should show 'League'
    And the page should show 'Jeder gegen Jeden'
    And the page should show 'Team'

  Scenario: Missing capacity
    Given a league without max teams
    When the league's page is visited
    Then the page should show 'unbegrenzt'

  Scenario: Organizer name displayed
    Given an event e
    And user o is organizer of event e
    When visiting the event page of e
    Then o should be listed as organizer
    And clicking on the name should lead to the profile page of o


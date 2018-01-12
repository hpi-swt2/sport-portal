Feature: League creation
  As a user
  In order to easily create a League
  I want to have a two step creation form

  Scenario: League form
    Given a user
    And the user is logged in
    When he visits the create event path
    And he clicks 'New league'
    Then the page should show 'Liga erstellen'
    And there should be an input 'Spieltagdauer'
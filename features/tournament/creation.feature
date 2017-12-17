Feature: Tournament creation
  As a user
  In order to easily create a tournament
  I want to have a two step creation form

  Scenario: Tournament form
    Given a user
    And the user is logged in
    When he visits the create event path
    And he clicks 'New tournament'
    Then the page should show 'Turnier erstellen'
    And there should be a dropdown 'Spielsystem' with options 'KO'

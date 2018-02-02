Feature: Tournament optional place 3 match
  As a user
  In order to have events in the form that I wish
  I want to make the place 3 match optional

  Scenario: Create match without place 3 match
    Given a user
    And the user is logged in
    When he visits the create event path
    And he clicks 'New tournament'
    And he fills in valid tournament data
    And he unchecks the checkbox 'Spiel um Platz 3'
    And he creates the tournament

    When 8 teams join the tournament
    And the schedule page is visited

    Then the text Spiel um Platz 3 is not there

  Scenario: Create match with place 3 match
    Given a user
    And the user is logged in
    When he visits the create event path
    And he clicks 'New tournament'
    And he fills in valid tournament data
    And he checks the checkbox 'Spiel um Platz 3'
    And he creates the tournament

    When 8 teams join the tournament
    And the schedule page is visited

    Then the text Spiel um Platz 3 is there

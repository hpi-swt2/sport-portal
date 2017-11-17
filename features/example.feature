Feature: Test feature

  Scenario: Test scenario
    Given a team a
    And a team b
    And a match between them
    When the matches page is visited
    Then it should show the name of team a
    And it should show the name of team b


  Scenario: a match
    Given a team a
    And a team b
    And a match between a and b
    When the matches page is visited
    Then it should show the names of the participating teams



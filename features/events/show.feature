Feature: Detailed event page

  Scenario: Tournament
    Given a tournament with gamemode ko
    When the tournament's page is visited
    Then the page header should show 'Tournament'
    And the page should show 'Ko'

  Scenario: League
    Given a league with gamemode round_robin
    When the league's page is visited
    Then the page header should show 'League'
    And the page should show 'Jeder gegen jeden'

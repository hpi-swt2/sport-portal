Feature: Detailed event page

  Scenario: Tournament
    Given a tournament with gamemode ko
    When the tournament's page is visited
    Then the page header should show 'Tournament'
    And the page should show 'Ko'
    And the page should show 'Teamteilnahme'

  Scenario: League
    Given a league with gamemode round_robin
    When the league's page is visited
    Then the page header should show 'League'
    And the page should show 'Jeder gegen Jeden'
    And the page should show 'Teamteilnahme'

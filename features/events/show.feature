Feature: Detailed event page

  Scenario: Tournament
    Given a tournament with gamemode ko
    When the tournament's page is visited
    Then the page header should show 'Tournament'
    And the page should show 'K.-o.-System'
    And the page should show 'Teamteilnahme'

  Scenario: League
    Given a league with gamemode round_robin
    When the league's page is visited
    Then the page header should show 'League'
    And the page should show 'Jeder gegen Jeden'
    And the page should show 'Teamteilnahme'

  Scenario: Missing capacity
    Given a league without max teams
    When the league's page is visited
    Then the page should show 'unlimited'

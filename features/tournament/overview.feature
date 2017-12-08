Feature: Tournament Overview Page
  As a tournament participant
  In order to see how far each team came / its status
  I want to have a page that shows the progress/history of the tournament

  Scenario: Tournament overview page should have a table with appropriate column names
    Given a tournament t
    When the tournament overview page for t is visited
    Then there should be a table
    And the table should have a column named 'events.overview.teamColumn'
    And the table should have a column named 'events.overview.standingColumn'
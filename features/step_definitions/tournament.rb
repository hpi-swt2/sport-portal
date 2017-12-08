Given(/^a tournament (.*)$/) do |tournamentName|
  create_tournament_named tournamentName
end

When(/^the tournament overview page for (.*) is visited$/) do |tournamentName|
  visit event_overview_path (tournament_named tournamentName)
end

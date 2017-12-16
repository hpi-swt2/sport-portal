Given(/^a tournament (.*) with (\d+) teams$/) do |tournamentName, numTeams|
  create_tournament_named tournamentName, max_teams: numTeams
  tournament = tournament_named tournamentName
  for each in 1..numTeams do
    tournament.teams << create_team
  end
end

Given(/^a tournament$/) do
  create_tournament
end

Given(/^a new tournament$/) do
  build_tournament
end

Given(/^a tournament (.*)\.$/) do |tournamentName|
  create_tournament_named tournamentName
end

When(/^the tournament overview page for (.*) is visited$/) do |tournamentName|
  visit event_overview_path (tournament_named tournamentName)
end

Given(/^a tournament with gamemode (.*)$/) do |mode|
  create_tournament game_mode: Tournament.game_modes[mode.to_sym]
end

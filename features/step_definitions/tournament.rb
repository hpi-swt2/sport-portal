

Given(/^a tournament (.*) with (\d+) teams$/) do |tournamentName, numTeams|
  create_tournament_named tournamentName, max_teams: numTeams
  tournament = tournament_named tournamentName
  for each in 1..numTeams do
    tournament.teams << create_team
  end
end

Given(/^a tournament (.*)\.$/) do |tournamentName|
  create_tournament_named tournamentName
end

When(/^the tournament overview page for (.*) is visited$/) do |tournamentName|
  visit event_overview_path (tournament_named tournamentName)
end


When(/^the event page for (.*) is visited$/) do |tournamentName|
  visit event_path (tournament_named tournamentName)
end

And(/^it should link to tournament Spielplan for (.*)$/) do |tournamentName|
  click_button 'zum Spielplan'
  expect(page).to have_current_path(event_schedule_path(tournament_named tournamentName), only_path: true)
end

When(/^the Spielplan page for (.*) is visited$/) do |tournamentName|
  visit event_schedule_path(tournament_named tournamentName)
end

Then(/^there should be several rounds$/) do
  expect(page).to have_content('Finale')
  expect(page).to have_content('Halbfinale')
end

And(/^there should be exactly (\d+) matches and (\d+) rounds$/) do |numberOfMatches, numberOfRounds|
  # The minus 1 is needed because the headline of the table is also a tr entry
  (page.all('table#matches-table tr').count - 1).should == (numberOfMatches + numberOfRounds)
end
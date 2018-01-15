Given /^a league with gamemode (.*)$/ do |mode|
  create_league game_mode: mode
end

Given(/^a league (.*) with (\d+) teams$/) do |leagueName, numTeams|
  create_league_named leagueName,  max_teams: numTeams,
                                   deadline: Date.parse('23.12.2017'),
                                   startdate: Date.parse('24.12.2017'),
                                   gameday_duration: 7
  league = league_named leagueName
  for each in 1..numTeams do
    league.teams << create_team
  end
  league.generate_schedule
end

Then(/^it should link to league schedule for (.*)$/) do |leagueName|
  click_link 'zum Spielplan'
  expect(page).to have_current_path(event_schedule_path(league_named leagueName), only_path: true)
end

When(/^the league page for (.*) is visited$/) do |leagueName|
  visit event_path (league_named leagueName)
end

When(/^the schedule page for (.*) is visited$/) do |leagueName|
  visit event_schedule_path(league_named leagueName)
end

Then (/^there should be gameday dates$/) do
  expect(page).to have_content('24.12. bis 30.12.')
  expect(page).to have_content('31.12. bis 06.01.')
end

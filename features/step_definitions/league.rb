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
  league.save
end

Then(/^it should link to league schedule for (.*)$/) do |leagueName|
  click_link 'zum Spielplan'
  expect(page).to have_current_path(event_schedule_path(league_named leagueName), only_path: true)
end

When(/^the league page for (.*) is visited$/) do |leagueName|
  visit event_path (league_named leagueName)
end

When(/^the schedule page for (.*) is visited$/) do |leagueName|
  visit event_schedule_path (league_named leagueName)
end

Then (/^there should be gameday dates$/) do
  expect(page).to have_selector("input[value='24.12.2017']")
  expect(page).to have_selector("input[value='24.12.2017']")
end

And (/^the change should be saved$/) do
  expect(page).to have_selector("input[value='10.05.2013']")
  expect(page).to have_selector("input[value='15.05.2013']")
end

Given(/^a league without max teams$/) do
  create_league(max_teams: nil)
end

And(/^the joining phase of (.*) is finished, so the playing schedule has been calculated$/) do |league|
  (league_named league).generate_schedule
end

When('visiting the game schedule') do
  pending # Write code here that turns the phrase above into concrete actions
end

And(/^user (.*) who is not organizer should not be able to do so$/) do |userName|
  step "a user #{userName}"
  step "#{userName} is logged in"

  visit event_schedule_path(league_named 'l')
  first(:css, "#gameday_starttime").set '10.05.2013'
  first(:css, "#gameday_endtime").set '15.05.2013'
  expect(page).not_to have_selector(:link_or_button, I18n.t('events.schedule.edit_date'))
end


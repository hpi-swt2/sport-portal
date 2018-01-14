Given(/^a tournament (.*) with (\d+) teams$/) do |tournamentName, numTeams|
  create_tournament_named tournamentName, max_teams: numTeams
  tournament = tournament_named tournamentName
  for each in 1..numTeams do
    tournament.teams << create_team
  end
  tournament.generate_schedule
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

When(/^the event page for (.*) is visited$/) do |tournamentName|
  visit event_path (tournament_named tournamentName)
end

Then(/^it should link to tournament Spielplan for (.*)$/) do |tournamentName|
  click_link 'zum Spielplan'
  expect(page).to have_current_path(event_schedule_path(tournament_named tournamentName), only_path: true)
end

When(/^the Spielplan page for (.*) is visited$/) do |tournamentName|
  visit event_schedule_path(tournament_named tournamentName)
end

And(/^the texts? (.+) (?:are|is) there\.$/) do |texts_raw|
  texts = texts_raw.split ', '
  texts.each do |text|
    expect(page).to have_text(text)
  end
end

Then(/^there should be several rounds$/) do
  expect(page).to have_content('Finale')
  expect(page).to have_content('Halbfinale')
end

Then(/^there should be exactly (\d+) matches and (\d+) rounds$/) do |numberOfMatches, numberOfRounds|
  # The minus 1 is needed because the headline of the table is also a tr entry
  expect(all('table#matches-table tr').count - 1).to eq(numberOfMatches + numberOfRounds)
end

def find_match_on_page(match_gameday, match_num)
  *_, match_id = find(:xpath, "(//table//th/b[contains(.,'#{match_gameday}')]/following::tr/td[1][contains(.,'#{match_num}')]/following::form)[1]")[:id].split '_'
  Match.find match_id.to_i
end

def find_team_of_match(match_gameday, match_num, home_or_away)
  match = find_match_on_page match_gameday, match_num
  {
      home: match.team_home_recursive,
      away: match.team_away_recursive
  }[home_or_away.to_sym]
end

Then(/^the results for match (.+) (\d+) \((\d+) : (\d+)\) got inserted$/) do |match_gameday, match_num, points_home, points_away|
  match = find_match_on_page match_gameday, match_num
  fill_in "match_#{match.id}_match_points_home", with: points_home
  fill_in "match_#{match.id}_match_points_away", with: points_away
  click_on "save_points_#{match.id}"
end

Then(/^the (home|away) team of match (.+) (\d+) comes to the next round$/) do |home_or_away, match_gameday, match_num|
  team = find_team_of_match match_gameday, match_num, home_or_away
  expect(all('a[href="' + team_path(team) + '"]').count).to eq(2)
end


Then(/^the (home|away) team of match (.+) (\d+) (is|isn't) in match (.+) (\d+)$/) do |home_or_away, match_gameday, match_num, is_or_isnt, target_match_gameday, target_match_num|
  team = find_team_of_match match_gameday, match_num, home_or_away
  target_match = find_match_on_page target_match_gameday, target_match_num
  expect(target_match.is_team_recursive? team).to be(is_or_isnt == 'is')
end

Then(/^the standing of the (home|away) team of match (.+) (\d+) is '(.+)'$/) do |home_or_away, match_gameday, match_num, standing|
  visit event_schedule_path single_tournament
  team = find_team_of_match match_gameday, match_num, home_or_away
  visit event_overview_path single_tournament
  expect(page).to have_text("#{team.name} #{standing}")
end

Given(/^a tournament with gamemode (.*)$/) do |mode|
  create_tournament game_mode: mode
end

def placing_to_display_string(placing)
  I18n.t "events.placing.#{placing}"
end

Then(/^the (first|second) place of the tournament is the (home|away) team of (.+) (\d+)$/) do |placing, home_or_away, match_gameday, match_num|
  visit event_schedule_path single_tournament
  team = find_team_of_match match_gameday, match_num, home_or_away
  visit event_path single_tournament
  expect(page).to have_text("#{placing_to_display_string placing} #{team.name}")
end

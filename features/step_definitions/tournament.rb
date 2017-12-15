

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

And(/^it should link to tournament Spielplan for (.*)$/) do |tournamentName|
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

And(/^there should be exactly (\d+) matches and (\d+) rounds$/) do |numberOfMatches, numberOfRounds|
  # The minus 1 is needed because the headline of the table is also a tr entry
  expect(all('table#matches-table tr').count - 1).to eq(numberOfMatches + numberOfRounds)
end

def find_match_on_page(match_num)
  *_, match_id = all('table#matches-table form')[match_num - 1][:id].split '_'
  Match.find match_id.to_i
end

def find_team_of_match(match_num, home_or_away)
  match = find_match_on_page match_num
  {
      home: match.team_home_recursive,
      away: match.team_away_recursive
  }[home_or_away.to_sym]
end

And(/^the results for match (\d+) \((\d+) : (\d+)\) got inserted$/) do |match_num, points_home, points_away|
  match = find_match_on_page match_num
  fill_in "match_#{match.id}_match_points_home", with: points_home
  fill_in "match_#{match.id}_match_points_away", with: points_away
  click_on "save_points_#{match.id}"
end

Then(/^the (home|away) team of match (\d+) comes to the next round$/) do |home_or_away, match_num|
  team = find_team_of_match match_num, home_or_away
  all('a[href="' + team_path(team) + '"]').count == 2
end

Then(/^the (home|away) team of match (\d+) (is|isn't) in match (\d+)$/) do |home_or_away, match_id, is_or_isnt, target_match_num|
  team = find_team_of_match match_id, home_or_away
  target_match = find_match_on_page target_match_num
  print target_match.debug_name + "\n"
  print team.name + "\n"
  expect(target_match.is_team_recursive? team).to be(is_or_isnt == 'is')
end

Then(/^the standing of the (home|away) team of match (\d+) is '(.+)'$/) do |home_or_away, match_num, standing|
  visit event_schedule_path single_tournament
  team = find_team_of_match match_num, home_or_away
  visit event_overview_path single_tournament
  expect(page).to have_text("#{team.name} #{standing}")
end
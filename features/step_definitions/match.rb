Given(/^a match between (.*) and (.*)$/) do |home, away|
  create_match(team_home: team_named(home), team_away: team_named(away))
end

Given(/^a match between them$/) do
  raise 'There are not enough teams' if @teams.count < 2
  raise "'Them' is ambiguous." if @teams.count > 2
  create_match(team_home: @teams[0], team_away: @teams[1])
end

Given(/^a match$/) do
  create_match
end

Then(/^it should show the names of the participating teams$/) do
  expect(page).to have_text(@matches.last.team_home.name)
  expect(page).to have_text(@matches.last.team_away.name)
end

Then(/^it should show the name of team (.*)$/) do |name|
  expect(page).to have_text(team_named(name).name)
end

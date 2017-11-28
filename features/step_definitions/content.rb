Then(/^it should show the names of the participating teams$/) do
  expect(page).to have_text(@matches.last.team_home.name)
  expect(page).to have_text(@matches.last.team_away.name)
end

Then(/^it should show the name of team (.*)$/) do |name|
  expect(page).to have_text(team_named(name).name)
end


Then(/^there should be a '(.*)' button$/) do |text|
  expect(page).to have_button(text)
end


Then(/^the '(.*)' input should already be filled with '(.*)'$/) do |name, text|
  expect(page).to have_field(name, with: text)
end


Then(/^there should be an input '(.*)'$/) do |name|
  expect(page).to have_field(name)
end

Then(/^there should not be an input '(.*)'$/) do |name|
  expect(page).to_not have_field(name)
end

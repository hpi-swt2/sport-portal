When /^he visits the create event path$/ do
  visit new_event_path
end

When /^he visits the new tournament path$/ do
  visit new_tournament_path
end

When(/^the tournament's page is visited$/) do
  visit event_path single_tournament
end

When(/^the league's page is visited$/) do
  visit event_path single_league
end

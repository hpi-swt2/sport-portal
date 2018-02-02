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

Then(/^there should be a '(.*)' link/) do |text|
  expect(page).to have_link(text)
end

When(/^he (checks|unchecks) the checkbox '(.*)'$/) do |action, checkbox_name|
  if action == 'unchecks'
    uncheck checkbox_name
  else
    check checkbox_name
  end
end

Then(/^there should be a table$/) do
  expect(page).to have_table
end

And(/^the table should have a column named '(.*)'$/) do |name|
  key = I18n.t name
  expect(page).to have_xpath("//table/thead/tr/th[contains(.,'" + key + "')]")
end

Then(/^the '(.*)' input should already be filled with '(.*)'$/) do |name, text|
  expect(page).to have_field(name, with: text)
end

Then /^there should be a dropdown '(.*)' with options '(.*)'$/ do |name, options|
  expect(page).to have_select(name, with_options: options.split(','))
end


Then(/^there should be an input '(.*)'$/) do |name|
  expect(page).to have_field(name)
end

Then(/^there should not be an input '(.*)'$/) do |name|
  expect(page).to_not have_field(name)
end


And(/^the table should have (\d+) rows$/) do |arg|
  expect(page).to have_xpath('//table/tbody/tr', count: arg)
end

Then(/^the page header should show '(.*)'$/) do |text|
  translations = {
    'Tournament' => ['activerecord.models.tournament.one'],
    'League' => ['activerecord.models.league.one']
  }
  expect(page).to have_xpath("//h1[contains(text(),'#{I18n.t *translations[text]}')]")
end


Then(/^there should be a back button on all pages except the start page$/) do
  # These routes were excluded in accordance with our PO
  excluded_routes = ['/', '/cable', '/tournaments/new', '/leagues/new', '/leagues/1/edit', '/tournaments/1/edit', '/events/1/edit', '/rankinglists/new', '/teams/new', '/teams/1/edit', '/matches/1/edit', '/my/users/sign_in', '/my/users/password/edit', '/my/users/cancel', '/my/users/sign_up', '/users/1/dashboard', '/users/1/edit', '/matches/1/add_game_result', '/matches/1/edit_results', '/users', '/my/users/password/new']

  Rails.application.routes.routes.each do |route|
    current_path = route.path.spec.to_s
    if current_path.include? '(.:format)'
      current_path['(.:format)'] = ''
    end
    if current_path.include? ':id'
      current_path[':id'] = '1'
    end

    # There are a lot of routes in Rails, that can't be visited in general
    begin
      visit current_path
    rescue Exception
      next
    end
    unless excluded_routes.include? current_path
       expect(page).to have_link(I18n.t ('helpers.links.back'))
    end
  end
end

Given(/^an event (.*)$/) do |eventName|
  create_event_named eventName
end

Given(/^user (.*) is organizer of event (.*)$/) do |userName, eventName|
  event = event_named eventName
  create_user_named userName
  user = user_named userName
  event.editors << user
  user
end

Then(/^(.*) should be listed as organizer$/) do |userName|
  user = user_named userName
  expect(page).to have_text(user.name)
end

And(/^clicking on the name should lead to the profile page of (.*)$/) do |userName|
  user = user_named userName
  expect(page).to have_selector(:link, user.name, href: user_path(user))
end
Given(/^any event (.*)$/) do |name|
  create_event_named(name)
end

Given(/^(.*) is not organizer of (.*)$/) do |username, eventname|
  event = event_named(eventname)
  user = user_named(username)
  event.organizers.map{ |organizer| organizer.user_id != user.id }
end

Then(/^(.*) should not be able to delete the event (.*) at any time$/) do |username, eventname|
  event = event_named(eventname)
  user = user_named(username)

  sign_in user
  visit event_path(event)
  expect(page).not_to have_css('a', :text => I18n.t('helpers.links.destroy'))
end

Given(/^an event that has not started yet$/) do
  create_event(startdate: Date.tomorrow)
end

Then(/^the admin should be able to delete it$/) do
  admin = create_user(admin: true)
  event = single_event

  sign_in admin
  visit event_path(event)
  expect(page).to have_css('a', :text => I18n.t('helpers.links.destroy'))
end


Given(/^the organizer should be able to delete it$/) do
  user = single_user
  event = single_event
  event.organizers << user

  sign_in user
  visit event_path(event)
  expect(page).to have_css('a', :text => I18n.t('helpers.links.destroy'))
end
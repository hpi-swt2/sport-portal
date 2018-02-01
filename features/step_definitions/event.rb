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

Given(/^an event (.*) that has not started yet$/) do |eventname|
  create_event_named(eventname, startdate: Date.tomorrow)
end

Then(/^admin (.*) should be able to delete (.*)$/) do |adminname, eventname|
  admin = create_user_named(adminname, admin: true)
  event = event_named(eventname)

  sign_in admin
  visit event_path(event)
  expect(page).to have_css('a', :text => I18n.t('helpers.links.destroy'))
end


Given(/^user (.*) who is an organizer should be able to delete (.*)$/) do |username, eventname|
  user = create_user_named(username)
  event = event_named(eventname)
  event.organizers << user

  sign_in user
  visit event_path(event)
  expect(page).to have_css('a', :text => I18n.t('helpers.links.destroy'))
end
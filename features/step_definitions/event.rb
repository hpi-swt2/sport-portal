Given(/^any event (.*)/) do |name|
  create_event_named(name)
end

Given(/^(.*) is not organizer of (.*)/) do |username, eventname|
  event = event_named(eventname)
  user = user_named(username)
  event.organizers.map{ |organizer| organizer.user_id != user.id }
end

Then(/^(.*) should not be able to delete the event (.*) at any time/) do |username, eventname|
  event = event_named(eventname)
  user = user_named(username)

  sign_in user
  visit event_path(event)
  expect(page).not_to have_css('a', :text => I18n.t('helpers.links.destroy'))
end
Given(/^(?:a|one) user/) do
  create_user
end

Given(/^a user (\w+)$/) do |name|
  create_user_named(name, first_name: name)
end

Given(/^the user is logged in$/) do
  raise 'There is no user' if @users.count < 1
  raise "'The user' is ambiguous." if @users.count > 1
  sign_in @users.last
end

Given(/^(\w+) is logged in$/) do |name|
  sign_in user_named name
end

When(/^the user views his account settings$/) do
  ensure_current_user!
  visit edit_user_registration_path
end


Then(/^the user should be linked with the account$/) do
  pending #TODO: User model migration
end


Then(/^the user should not be linked with the account$/) do
  pending #TODO: User model migration
end


Then(/^the user should be signed in$/) do
  pending #TODO: devise research
end

Given(/^(?:a|one) user$/) do
  create_user
end

Given(/^a user (\w+)$/) do |name|
  create_user_named(name, first_name: name)
end

Given(/^a user with a linked OpenID account$/) do
  account = create_omniauth_account provider: :hpiopenid
  create_user(provider: account[:provider], uid: account[:uid])
end

Given(/^a user (.*) with email (.*)$/) do |username, email|
  create_user_named(username, email: email)
end

Given(/^a new user (.*) with email (.*)$/) do |username, email|
  build_user_named(username, email: email)
end

Given(/^a new user (.*) with a blank first name field$/) do |username|
  build_user_named(username, first_name: '')
end

Given(/^a new user (.*) with a blank last name field$/) do |username|
  build_user_named(username, last_name: '')
end

Given(/^a new user (.*) with password (.*)$/) do |username, password|
  build_user_named(username, password: password)
end

Given(/^the user is logged in$/) do
  sign_in single_user
end

Given(/^(\w+) is logged in$/) do |name|
  sign_in user_named name
end

When(/^he views his account settings$/) do
  ensure_current_user!
  visit edit_user_registration_path
end

When(/^(.*) tries to sign up$/) do |username|
  user = user_named(username)
  visit new_user_registration_path
  fill_in :user_first_name, with: user.first_name
  fill_in :user_last_name, with: user.last_name
  fill_in :user_email, with: user.email
  fill_in :user_password, with: user.password
  fill_in :user_password_confirmation, with: user.password
  click_button I18n.t('devise.registrations.sign_up')
end

Then(/^the user should be linked with the account$/) do
  user = single_user
  account = single_account
  user.reload
  expect(user.uid).to eq(account[:uid])
  expect(user.provider).to eq(account[:provider])
end

Then(/^the user should not be linked with any account$/) do
  user = single_user
  user.reload
  expect(user.uid).to be_nil
  expect(user.provider).to be_nil
end

Then(/^(\w+) should not be linked with any account$/) do |name|
  user = user_named(name)
  user.reload
  expect(user.uid).to be_nil
  expect(user.provider).to be_nil
end

Then(/^the sign in should have been successful$/) do
  expect(page).to have_css('.alert-success')
end

Then(/^(.*) should not be able to sign up$/) do |username|
  found_users = User.all.select do |user|
    user.first_name.eql?(user_named(username).first_name) && user.last_name.eql?(user_named(username).last_name) && user.email.eql?(user_named(username).email)
  end
  expect(found_users.any?).to be_falsey
end

And(/^the page should show (.*)$/) do |message|
  expect(page).to have_text(message)
end
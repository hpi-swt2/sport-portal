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

Given(/^a new user$/) do
  build_user
end

Given(/^a new user (.*) with email (.*)$/) do |username, email|
  build_user_named(username, email: email)
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

Then(/^the new user should be linked with the account$/) do
  account = single_account
  user = User.find_by(email: account.info.email)
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
  expect(user_named(username).persisted?).to be_falsey
end

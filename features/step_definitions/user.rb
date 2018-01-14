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
  create_user
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

Given(/^(\w+) is (?:logged|able to log)? in(?: again)?$/) do |name|
  sign_in user_named name
end

When(/^he views his account settings$/) do
  ensure_current_user!
  visit edit_user_path(@users.last)
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
  user = User.find_by(first_name: user_named(username).first_name, last_name: user_named(username).last_name, email: user_named(username).email)
  expect(user).to be_nil
end

And(/^the page should show '(.*)'$/) do |message|
  expect(page).to have_text(message)
end


When(/^he visits the password recovery page$/) do
  visit new_user_password_path
end

And(/^(.+) inserts his email address$/) do |username|
  user = user_named(username)
  fill_in :user_email, with: user.email
end

And(/^submits$/) do
  click_button I18n.t('devise.registrations.reset_password')
end

Then(/^(\w+) gets an Email with a recovery link$/) do |username|
  user = user_named(username)
  open_email(user.email)
  expect(current_email.subject).to have_content(I18n.t('devise.mailer.reset_password_instructions.subject'))
  expect(current_email).to have_link(I18n.t('devise.mailer.reset_password_instructions.action'))
end

When(/^he clicks the recovery link$/) do
  current_email.click_link I18n.t('devise.mailer.reset_password_instructions.action')
end

And(/^he enters a new password$/) do
  fill_in :user_password, with: '12345678_my_new_password'
  fill_in :user_password_confirmation, with: '12345678_my_new_password'
  click_button I18n.t('devise.registrations.confirm_new_password')
end

When(/^(\w+) is stored in the database$/) do |username|
  user = user_named username
  user.save!
end

And(/^he logs out$/) do
  sign_out
end

And (/^he changes his email/) do
  fill_in :user_email, with: 'new' + single_user.email
end

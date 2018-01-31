Given(/^an unlinked OpenID account$/) do
  create_omniauth_account provider: :hpiopenid
end

Given(/^an unlinked OpenID account with email '([^']*)'$/) do |email|
  create_omniauth_account provider: :hpiopenid, info: { email: email }
end

Given(/^an unlinked OpenID account with email '([^']*)', first name '([^']*)' and last name '([^']*)'$/) do |email, first_name, last_name|
  create_omniauth_account provider: :hpiopenid, info: {
    email: email,
    first_name: first_name,
    last_name: last_name
  }
end

Given(/^the account is used for authentication$/) do
  authenticate_with single_account
end

When(/^the account is used to sign in$/) do
  authenticate_with single_account
  visit new_user_session_path
  click_on I18n.t('devise.registrations.sign_in_with_provider', provider: 'OpenID')
end

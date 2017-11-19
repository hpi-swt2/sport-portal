Given(/^an unlinked OpenID account$/) do
  create_account
end

Given(/^the account is used for authentication$/) do
  authenticate_with single_account
end


When(/^the account is used to sign in$/) do
  authenticate_with single_account
  visit new_user_session_path
  click_button I18n.t('devise.registrations.sign_in_with_provider', provider: 'OpenID')
end

When (/^he clicks '(.*)'$/) do |text|
  translations = {
    'Connect with OpenID' => ['devise.registrations.link_provider', provider: 'OpenID'],
    'Disconnect from OpenID' => ['devise.registrations.unlink_provider', provider: 'OpenID']
  }
  translations.default = 'No translation found'

  click_on I18n.t(*translations[text])
end


When(/^the user enters his name$/) do
  user = single_user
  fill_in 'First name', with: user.first_name
  fill_in 'Last name', with: user.last_name
end


When(/^the user submits the form$/) do
  find('input[name="commit"]').click
end

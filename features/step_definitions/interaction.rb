When (/^he clicks '(.*)'$/) do |text|
  translations = {
    'Connect with OpenID' => ['devise.registrations.link_provider', provider: 'OpenID'],
    'Disconnect from OpenID' => ['devise.registrations.unlink_provider', provider: 'OpenID']
  }
  translations.default = 'No translation found'

  click_on I18n.t(*translations[text])
end
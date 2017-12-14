When (/^he clicks '(.*)'$/) do |text|
  translations = {
    'Connect with OpenID' => ['devise.registrations.link_provider', provider: 'OpenID'],
    'Disconnect from OpenID' => ['devise.registrations.unlink_provider', provider: 'OpenID'],
    'New tournament' => ['events.new_tournament']
  }
  translations.default = 'No translation found'

  click_on I18n.t(*translations[text])
end

When(/^the user enters his name$/) do
  user = single_user
  fill_in User.human_attribute_name(:first_name), with: user.first_name
  fill_in User.human_attribute_name(:last_name), with: user.last_name
end

When(/^the user submits the form$/) do
  find('input[name="commit"]').click
end

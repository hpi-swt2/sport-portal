require 'rails_helper'

RSpec.feature 'OpenID signup', :type => :feature do
  scenario 'A new user signs in with OpenID for the first time and signs up' do
    OmniAuth.config.test_mode = true
    user_attributes = FactoryBot.attributes_for(:user)
    options = {
      uid: '1234567890',
      info: {
        email: user_attributes[:email]
      }
    }
    auth = OmniAuth.config.add_mock(:hpiopenid, options)
    visit new_user_session_path
    click_on I18n.t('devise.registrations.sign_in_with_provider', provider: 'OpenID')

    within('form', id: 'new_user') do
      fill_in 'user[first_name]', with: user_attributes[:first_name]
      fill_in 'user[last_name]', with: user_attributes[:last_name]
      find('input[name="commit"]').click
    end
    user = User.find_by(email: user_attributes[:email])
    expect(user.first_name).to eq(user_attributes[:first_name])
    expect(user.last_name).to eq(user_attributes[:last_name])
    expect(user.provider).to eq(auth.provider)
    expect(user.uid).to eq(auth.uid)
  end
end

require 'rails_helper'

describe "application", type: :feature do

  it "should show notification to user after successful sign in" do
    user = FactoryBot.create(:user, password: 'asdfasdf', password_confirmation: 'asdfasdf')
    visit new_user_session_path

    within('form', id: 'new_user') do
      fill_in "user[email]", with: user[:email]
      fill_in "user[password]", with: 'asdfasdf'
      find('input[type="submit"]').click
    end
    expect(page).to have_css('div.alert.custom-notification', text: I18n.t('devise.sessions.signed_in'))
  end

end

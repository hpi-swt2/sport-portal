require "rails_helper"

RSpec.feature "User management", type: :feature do
  scenario "User signs in and finds himself on his dashboard" do
    user = FactoryBot.create(:user, password: '12345678a', password_confirmation: '12345678a')
    visit new_user_session_path

    within('form', id: 'new_user') do
      fill_in "user[email]", with: user[:email]
      fill_in "user[password]", with: '12345678a'
      find('input[type="submit"]').click
    end
    expect(page).to have_css(
      'h1',
      text: I18n.t('dashboard.title', name: user.first_name))
  end

  scenario "User visits sign in page and can see link to sign up page" do
    visit new_user_session_path

    expect(page).to have_link(href: new_user_registration_path)
  end

  scenario "User sees OpenID sign in button prominently placed at the top" do
    visit new_user_session_path

    expect(page).to have_css(
      'form > .row:first-of-type a.openIdButton',
      text: I18n.t('devise.registrations.sign_in_with_provider', provider: 'OpenID')
    )
  end
end

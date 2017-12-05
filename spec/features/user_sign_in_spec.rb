require "rails_helper"

RSpec.feature "User management", type: :feature do
  scenario "User signs in and finds himself on his dashboard" do
    user = FactoryBot.create(:user, password: '123456', password_confirmation: '123456')
    visit new_user_session_path

    within('form', id: 'new_user') do
      fill_in "user[email]", with: user[:email]
      fill_in "user[password]", with: '123456'
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
end

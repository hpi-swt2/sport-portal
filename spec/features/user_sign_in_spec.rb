require "rails_helper"

RSpec.feature "User management", :type => :feature do
  scenario "User signs in and finds himself on his dashboard" do
    user = FactoryBot.create(:user, password: '12345678a', password_confirmation: '12345678a')
    visit new_user_session_path

    within('form', id: 'new_user') do
      fill_in "user[email]", :with => user[:email]
      fill_in "user[password]", :with => '12345678a'
      find('input[type="submit"]').click
    end
      expect(page).to have_text("Dashboard for " + user[:first_name])
  end
end

require "rails_helper"

RSpec.feature "User management", :type => :feature do

  before(:each) do
    @user = FactoryBot.create(:user)
  end

  after(:each) do
    @user.destroy
  end

  scenario "User signs up" do
    attrs = FactoryBot.attributes_for(:user)
    visit new_user_registration_path

    within('form', id: 'new_user') do
      # fill_in can also locate input fields by their 'name' attribute
      # http://www.rubydoc.info/github/jnicklas/capybara/Capybara/Node/Actions:fill_in
      fill_in "user[first_name]", :with => attrs[:first_name]
      fill_in "user[email]", :with => attrs[:email]
      fill_in "user[password]", :with => attrs[:password]
      fill_in "user[password_confirmation]", :with => attrs[:password_confirmation]
      find('input[type="submit"]').click
    end

    expect(page).to have_text(I18n.t('devise.registrations.signed_up'))
  end

  scenario "User signs out from root page" do
    sign_in @user
    visit root_path
    find("a[href='#{destroy_user_session_path}']").click

    expect(page).to have_text(I18n.t('devise.sessions.signed_out'))
  end
end

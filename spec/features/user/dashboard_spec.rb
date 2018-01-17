require "rails_helper"

RSpec.feature "View Dashboard", type: :feature do
  let(:user) { FactoryBot.create :user }
  let(:admin) { FactoryBot.create :admin }

  scenario "User can access his dashboard from user dropdown menu" do
    sign_in user
    visit root_path

    click_on(text: user.first_name, class: 'dropdown-toggle')
    within('nav'){
      click_on(I18n.t('navbar.drop-down.dashboard'))
    }

    expect(page).to have_css(
      'h1',
      text: I18n.t('dashboard.title', name: user.first_name))
  end

  scenario "Admin can access any user's dashboard" do
    sign_in admin
    visit dashboard_user_path(user)

    expect(page).to have_css(
      'h1',
      text: I18n.t('dashboard.title', name: user.first_name))
  end

end

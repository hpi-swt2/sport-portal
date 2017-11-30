require 'rails_helper'

RSpec.feature "Page has navbar", :type => :feature do
  context 'when the user is signed in' do
    before(:each) do
      @user = FactoryBot.create(:user)
      sign_in @user
    end

    it "has a dropdown menu" do
      visit root_path
      expect(page).to have_css(".navbar .dropdown")
    end

    it "dropdown menu shows user name" do
      visit root_path
      expect(page).to have_css(".navbar .dropdown-toggle", text: @user.first_name)
    end

    it "the dropdown menu should have an item to get to the user dashboard" do
      visit root_path
      expect(page).to have_link(I18n.t('navbar.drop-down.dashboard'))
    end

  end

  context 'when the user is logged out' do
    it "doesn't have a dropdown menu" do
      visit root_path
      expect(page).not_to have_css(".navbar .dropdown")
    end
  end
end

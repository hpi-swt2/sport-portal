require 'rails_helper'

RSpec.feature "Page has navbar", :type => :feature do
  context 'when the user is signed in' do
    before(:each) do
      user = FactoryBot.create(:user)
      sign_in user
    end

    it "has a dropdown menu" do
      visit root_path
      expect(page).to have_css(".navbar .dropdown")
    end

    it "dropdown menu shows menu button" do
      visit root_path
      expect(page).to have_css(".navbar .dropdown-toggle", :text => "Menu")
    end

    it "opens dropdown when hovered over" do
      visit root_path
      pending("hover test is not working yet")
      find(".dropdown").hover
      expect(page).to have_css(".navbar .dropdown-menu", :text => "Sign out")
    end
  end

  context 'when the user logged out' do
    it "doesn't have a dropdown menu" do
      visit root_path
      expect(page).not_to have_css(".navbar .dropdown")
    end

    it "has a login button" do
      visit root_path
      expect(page).to have_css(".navbar", :text => "Sign in")
    end
  end
end
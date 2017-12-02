require 'rails_helper'

RSpec.feature "User avatar in navbar", :type => :feature do
  context 'user is signed in' do
    context 'the user has uploaded an avatar' do
      scenario "User sees his avatar in navbar" do
        user = FactoryBot.create :user, :with_avatar
        sign_in user
        visit root_path

        expect(page).to have_css(".navbar img[src='#{user.avatar_url}']")
      end

      scenario "User sees delete checkbox for his avatar" do
        user = FactoryBot.create :user, :with_avatar
        sign_in user
        visit edit_user_registration_path

        expect(page).to have_css("input[id='user_remove_image']")
      end
      
    end

    context 'the user has no avatar' do
      scenario "User sees a placeholder avatar in navbar" do
        user = FactoryBot.create :user
        sign_in user
        visit root_path
        image_path = ActionController::Base.helpers.asset_path("missing_avatar.png")

        expect(page).to have_css(".navbar img[src='#{image_path}']")
      end

      scenario "User sees no delete checkbox for his avatar" do
        user = FactoryBot.create :user
        sign_in user
        visit edit_user_registration_path

        expect(page).not_to have_css("input[id='user_remove_image']")
      end
    end
  end

  context 'user is not signed in' do
    scenario 'User sees no avatar in navbar' do
      visit root_path

      expect(page).not_to have_css('.navbar img')
    end
  end
end

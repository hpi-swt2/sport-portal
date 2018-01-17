require 'rails_helper'

RSpec.feature "User avatar in navbar", type: :feature do
  context 'user is signed in' do
    context 'the user has uploaded an avatar' do
      scenario "User sees his avatar in navbar" do
        user = FactoryBot.create :user, :with_avatar
        sign_in user
        visit root_path
        expect(page).to have_css(".navbar img[src='#{user.avatar_url}']")
      end
    end

    context 'the user has no avatar' do
      scenario "User sees a placeholder avatar in navbar" do
        user = FactoryBot.create :user
        sign_in user
        visit root_path
        expect(page).to have_css(".navbar img[src='https://owncloud.hpi.de/index.php/s/57REqYtqsah3A7o/download']")
      end
    end
  end

  context 'user is not signed in' do
    scenario 'User sees no avatar in navbar' do
      visit root_path
      expect(page).not_to have_css('.navbar .avatar img')
    end
  end
end

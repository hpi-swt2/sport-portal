require 'rails_helper'

describe 'Show team page', type: :feature do
  before(:each) do
    @team = FactoryBot.create :team
    @user = FactoryBot.create :user
  end

  describe 'invite users to team by email' do
    before(:each) do
      sign_in @user
    end

    it 'should work for team members' do
      @team.members << @user
      another_user = FactoryBot.create :user
      visit team_path @team
      click_on I18n.t('teams.show.invite_user_to_team')
      fill_in User.human_attribute_name(:email), with: another_user.email
      click_on I18n.t('helpers.links.send')
      expect(page).to have_text another_user.first_name
    end
  end

  describe 'display consecutive numbering of members' do
    before(:each) do
      sign_in @user
    end

    it 'should not show an id column for members' do
      @team.members << @user
      visit team_path @team
      expect(page).to_not have_text "Id"
    end

    it 'should show # column for members' do
      @team.members << @user
      visit team_path @team
      expect(page).to have_text "#"
    end
  end
end

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
      expect(page).to_not have_text User.human_attribute_name(:id)
    end

    it 'should actually number teams consecutively' do
      @another_user = FactoryBot.create :user
      @yet_another_user = FactoryBot.create :user
      @team.members << @user
      @team.members << @another_user
      @team.members << @yet_another_user
      visit team_path @team

      all('.table tr > td:nth-child(2)').each_with_index do |td, i|
        expect(td.text).to eq((i + 1).to_s)
        break if i == 2
      end
    end

    it 'should render correct "Send Email" links for team members' do
      sign_in @user
      @team.members << @user
      visit team_path @team
      mailto_link_for_user = 'mailto:' + @user.email
      expect(page).to have_link(href: mailto_link_for_user)
    end
  end
end

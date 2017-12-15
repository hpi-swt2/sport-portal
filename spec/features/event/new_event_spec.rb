require 'rails_helper'

describe 'new event page', type: :feature do
  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
  end

  context 'for a league' do
    let(:new_path) { new_league_path } # /new?type=league

    it 'should render without errors' do
        visit new_path
      end

    it 'should be possible to enter date conditions' do
      visit new_path

      expect(page).to have_field(Event.human_attribute_name :deadline)
      expect(page).to have_field(Event.human_attribute_name :startdate)
      expect(page).to have_field(Event.human_attribute_name :enddate)
    end

    it 'should have a field for league duration' do
      visit new_path

      expect(page).to have_field('event_duration')
    end

    it 'should be possible to create a date conditions' do
      visit new_path
      fill_in Event.human_attribute_name(:name), with: 'name'
      fill_in Event.human_attribute_name(:discipline), with: 'soccer'
      select 'Round robin', from: Event.human_attribute_name(:game_mode)
      select 'Single', from: Event.human_attribute_name(:player_type)
      fill_in Event.human_attribute_name(:max_teams), with: '5'

      fill_in Event.human_attribute_name(:deadline), with: Date.tomorrow.to_s
      fill_in Event.human_attribute_name(:startdate), with: (Date.tomorrow + 2).to_s
      fill_in Event.human_attribute_name(:enddate), with: (Date.tomorrow + 3).to_s

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/(events|tournaments|leagues)\/\d+/)
      expect(page).to have_content(Date.tomorrow.to_s)
      expect(page).to have_content((Date.tomorrow + 2).to_s)
      expect(page).to have_content((Date.tomorrow + 3).to_s)
    end
  end

  context 'for a tournament' do
    let(:new_path) { new_tournament_path } # /new?type=tournament

    it 'should render without errors' do
      visit new_path
    end

    it 'should be possible to enter date conditions' do
      visit new_path

      expect(page).to have_field(Event.human_attribute_name :deadline)
      expect(page).to have_field(Event.human_attribute_name :startdate)
      expect(page).to have_field(Event.human_attribute_name :enddate)
    end

    it 'should have a field for league duration' do
      visit new_path

      expect(page).to have_field('event_duration')
    end

    it 'should be possible to create a date conditions' do
      visit new_path

      fill_in Event.human_attribute_name(:name), with: 'name'
      fill_in Event.human_attribute_name(:discipline), with: 'soccer'
      select 'Ko', from: Event.human_attribute_name(:game_mode)
      select 'Single', from: Event.human_attribute_name(:player_type)
      fill_in Event.human_attribute_name(:max_teams), with: '5'

      fill_in Event.human_attribute_name(:deadline), with: Date.tomorrow.to_s
      fill_in Event.human_attribute_name(:startdate), with: (Date.tomorrow + 2).to_s
      fill_in Event.human_attribute_name(:enddate), with: (Date.tomorrow + 3).to_s

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/(events|tournaments|leagues)\/\d+/)
      expect(page).to have_content(Date.tomorrow.to_s)
      expect(page).to have_content((Date.tomorrow + 2).to_s)
      expect(page).to have_content((Date.tomorrow + 3).to_s)
    end
  end


end

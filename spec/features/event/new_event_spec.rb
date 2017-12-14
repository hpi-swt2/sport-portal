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

      expect(page).to have_field("event_deadline")
      expect(page).to have_field("event_startdate")
      expect(page).to have_field("event_enddate")
    end

    it 'should have a field for league duration' do
      visit new_path

      expect(page).to have_field('event_duration')
    end

    it 'should be possible to create a date conditions' do
      visit new_path
      fill_in Event.human_attribute_name(:name), with: 'name'
      fill_in Event.human_attribute_name(:discipline), with: 'soccer'
      select I18n.t('events.gamemode.round_robin'), from: "league_game_mode"
      select I18n.t('activerecord.attributes.event.player_types.single'),
             from: "event_player_type"
      fill_in Event.human_attribute_name(:max_teams), with: '5'

      fill_in "event_deadline", with: Date.tomorrow.to_s
      fill_in "event_startdate", with: (Date.tomorrow + 2).to_s
      fill_in "event_enddate", with: (Date.tomorrow + 3).to_s

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/(events|tournaments|leagues)\/\d+/)
      expect(page).to have_content(Date.tomorrow.to_s)
      expect(page).to have_content((Date.tomorrow + 2).to_s)
      expect(page).to have_content((Date.tomorrow + 3).to_s)
    end
  end

  context "for ranking lists" do
    before :each do
      visit new_rankinglist_path
    end

    it "should show a field for choosing the ranking metric" do
      expect(page).to have_field('rankinglist_game_mode')
    end

    it "should show a field for choosing the initial value of the ranking metric" do
      expect(page).to have_field('event_initial_value')
    end

    it "should not show a field for defining a deadline" do
      expect(page).not_to have_field('event_deadline')
    end

    it "should not show a field for defining a enddate " do
      expect(page).not_to have_field('event_enddate')
    end

    it "should not show a field for defining a startdate" do
      expect(page).not_to have_field('event_startdate')
    end

    it "should not show a field for defining whether its a team or single player sport" do
      expect(page).not_to have_field('event_player_type')
    end

    it "should not show a field for the duration" do
      expect(page).not_to have_field('event_duration')
    end

    it "should be possible to create a rankinglist" do
      fill_in "rankinglist_name", with: 'name'
      fill_in Event.human_attribute_name(:discipline), with: 'soccer'
      select I18n.t('events.gamemode.elo'), from: "rankinglist_game_mode"
      fill_in Event.human_attribute_name(:max_teams), with: '5'
      fill_in "event_initial_value", with: "1.3"

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/rankinglists\/\d+/)
    end
  end

  context 'for a tournament' do
    let(:new_path) { new_tournament_path } # /new?type=tournament

    it 'should render without errors' do
      visit new_path
    end

    it 'should be possible to enter date conditions' do
      visit new_path

      expect(page).to have_field("event_deadline")
      expect(page).to have_field("event_startdate")
      expect(page).to have_field("event_enddate")
    end

    it 'should have a field for league duration' do
      visit new_path

      expect(page).to have_field('event_duration')
    end

    it 'should be possible to create a date conditions' do
      visit new_path

      fill_in Event.human_attribute_name(:name), with: 'name'
      fill_in Event.human_attribute_name(:discipline), with: 'soccer'
      select I18n.t('events.gamemode.ko'), from: "tournament_game_mode"
      select I18n.t('activerecord.attributes.event.player_types.single'),
             from: "event_player_type"
      fill_in Event.human_attribute_name(:max_teams), with: '5'

      fill_in "event_deadline", with: Date.tomorrow.to_s
      fill_in "event_startdate", with: (Date.tomorrow + 2).to_s
      fill_in "event_enddate", with: (Date.tomorrow + 3).to_s

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/(events|tournaments|leagues)\/\d+/)
      expect(page).to have_content(Date.tomorrow.to_s)
      expect(page).to have_content((Date.tomorrow + 2).to_s)
      expect(page).to have_content((Date.tomorrow + 3).to_s)
    end
  end
end

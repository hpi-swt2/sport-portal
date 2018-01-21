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
      select League.human_game_mode(:round_robin), from: Event.human_attribute_name(:game_mode)
      select Event.human_player_type(:single), from: Event.human_attribute_name(:player_type)
      fill_in Event.human_attribute_name(:max_teams), with: '5'
      page.attach_file("league_image", "#{Rails.root}/spec/fixtures/valid_avatar.png")

      fill_in Event.human_attribute_name(:deadline), with: Date.tomorrow.to_s
      fill_in Event.human_attribute_name(:startdate), with: (Date.tomorrow + 2).to_s
      fill_in Event.human_attribute_name(:enddate), with: (Date.tomorrow + 3).to_s
      fill_in Event.human_attribute_name(:gameday_duration), with: '1'

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/leagues\/\d+/)
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
      expect(page).to have_field('rankinglist_initial_value')
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
      rankinglist = FactoryBot.build :rankinglist

      fill_in Event.human_attribute_name(:name), with: rankinglist.name
      fill_in Event.human_attribute_name(:discipline), with: rankinglist.discipline
      select Rankinglist.human_game_mode(:true_skill), from: Event.human_attribute_name(:game_mode)
      fill_in Event.human_attribute_name(:max_teams), with: rankinglist.max_teams
      fill_in Event.human_attribute_name(:initial_value), with: rankinglist.initial_value

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
      select Tournament.human_game_mode(:ko), from: Event.human_attribute_name(:game_mode)
      select Event.human_player_type(:single), from: Event.human_attribute_name(:player_type)
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

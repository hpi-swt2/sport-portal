require 'rails_helper'

describe 'new event page', type: :feature do

  def fill_in_fields_with(fields = {})
    fields.each do |field_symbol, input|
      fill_in Event.human_attribute_name(field_symbol), with: input
    end
  end

  def select_dropdowns_with(dropdowns = {})
    dropdowns.each do |dropdown, input|
      select input, from: dropdown
    end
  end

  def has_input_fields(*fields)
    fields.each do |field|
      expect(page).to have_field(Event.human_attribute_name field)
    end
  end

  def has_content(fields)
    fields.each do |field, content|
      expect(page).to have_content(Event.human_attribute_name field)
      expect(page).to have_content content
    end
  end

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

      has_input_fields :deadline, :startdate, :enddate
    end

    it 'should have a field for league duration' do
      visit new_path

      expect(page).to have_field 'event_duration'
    end

    let(:league) { FactoryBot.build(:league) }
    let(:valid_league_input_fields) { { name: league.name,
                                        discipline: league.discipline,
                                        max_teams: league.max_teams,
                                        gameday_duration: league.gameday_duration,
                                        deadline: league.deadline,
                                        startdate: league.startdate,
                                        enddate: league.enddate } }
    let(:valid_league_dropdowns) { { Event.human_attribute_name(:game_mode) => League.human_game_mode(:round_robin),
                                     Event.human_attribute_name(:player_type) => Event.human_player_type(:single) } }

    it 'should be possible to create a league' do
      visit new_path

      attach_file('league_image', "#{Rails.root}/spec/fixtures/valid_avatar.png")
      select_dropdowns_with valid_league_dropdowns
      fill_in_fields_with valid_league_input_fields


      find('input[type="submit"]').click
      has_content valid_league_input_fields
      has_content valid_league_dropdowns

      expect(page).to have_current_path(/.*\/leagues\/\d+/)
    end
  end

  context 'for ranking lists' do
    before :each do
      visit new_rankinglist_path
    end

    it 'should show a field for choosing the ranking metric' do
      expect(page).to have_field('rankinglist_game_mode')
    end

    it 'should show a field for choosing the initial value of the ranking metric' do
      expect(page).to have_field('rankinglist_initial_value')
    end

    it 'should not show a field for defining a deadline' do
      expect(page).not_to have_field('event_deadline')
    end

    it 'should not show a field for defining a enddate ' do
      expect(page).not_to have_field('event_enddate')
    end

    it 'should not show a field for defining a startdate' do
      expect(page).not_to have_field('event_startdate')
    end

    it 'should not show a field for defining whether its a team or single player sport' do
      expect(page).not_to have_field('event_player_type')
    end

    it 'should not show a field for the duration' do
      expect(page).not_to have_field('event_duration')
    end
    let(:rankinglist) { FactoryBot.build :rankinglist }
    let(:ranking_list_input_fields) { { name: rankinglist.name, discipline: rankinglist.discipline,
                                        max_teams: rankinglist.max_teams, initial_value: rankinglist.initial_value } }

    it 'should be possible to create a rankinglist' do
      fill_in_fields_with ranking_list_input_fields
      select Rankinglist.human_game_mode(:elo), from: Event.human_attribute_name(:game_mode)

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/rankinglists\/\d+/)
      has_content ranking_list_input_fields.except(:initial_value)
    end
  end

  context 'for a tournament' do
    let(:new_path) { new_tournament_path } # /new?type=tournament

    it 'should render without errors' do
      visit new_path
    end

    it 'should be possible to enter date conditions' do
      visit new_path

      has_input_fields :deadline, :startdate, :enddate
    end

    it 'should have a field for tournament duration' do
      visit new_path

      expect(page).to have_field 'event_duration'
    end

    let(:tournament) { FactoryBot.build(:tournament) }
    let(:valid_tournament_input_fields) { { name: tournament.name,
                                            discipline: tournament.discipline,
                                            max_teams: tournament.max_teams,
                                            deadline: tournament.deadline,
                                            startdate: tournament.startdate,
                                            enddate: tournament.enddate } }
    let(:valid_tournament_dropdowns) { { Event.human_attribute_name(:player_type) => Event.human_player_type(:single) } }
    it 'should be possible to create a tournament' do
      visit new_path

      fill_in_fields_with valid_tournament_input_fields
      select_dropdowns_with valid_tournament_dropdowns
      attach_file('tournament_image', "#{Rails.root}/spec/fixtures/valid_avatar.png")

      find('input[type="submit"]').click

      expect(page).to have_current_path(/.*\/tournaments\/\d+/)
      has_content valid_tournament_input_fields
      has_content valid_tournament_dropdowns
    end
  end
end

require 'rails_helper'

RSpec.describe 'events/new', type: :view do
  context 'new league' do
    before(:each) do
      assign(:event, FactoryBot.build(:league))
    end
    it 'should render the events form' do
      render
      expect(rendered).to have_css("form[action='#{leagues_path}'][method='post']", count: 1)
    end

    it 'has input for all attributes' do
      render

      expect(rendered).to have_field("league_name")
      expect(rendered).to have_field("event_description")
      expect(rendered).to have_select("league_game_mode")
      expect(rendered).to have_select("event_player_type")
      expect(rendered).to have_field("league_max_teams")
      expect(rendered).to have_field("league_discipline")
      expect(rendered).to have_field("event_deadline")
      expect(rendered).to have_field("event_startdate")
      expect(rendered).to have_field("event_enddate")
      expect(rendered).to have_field("event_min_players_per_team")
      expect(rendered).to have_field("event_max_players_per_team")
    end
  end

  context 'new tournament' do
    before(:each) do
      assign(:event, FactoryBot.build(:tournament))
    end
    it 'should render the events form' do
      render
      expect(rendered).to have_css("form[action='#{tournaments_path}'][method='post']", count: 1)
    end

    it 'has input for all attributes' do
      render

      expect(rendered).to have_field("tournament_name")
      expect(rendered).to have_field("event_description")
      expect(rendered).to have_select("tournament_game_mode")
      expect(rendered).to have_select("event_player_type")
      expect(rendered).to have_field("tournament_max_teams")
      expect(rendered).to have_field("tournament_discipline")
      expect(rendered).to have_field("event_deadline")
      expect(rendered).to have_field("event_startdate")
      expect(rendered).to have_field("event_enddate")
      expect(rendered).to have_field("event_min_players_per_team")
      expect(rendered).to have_field("event_max_players_per_team")
    end
  end
end

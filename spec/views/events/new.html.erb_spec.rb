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

      expect(rendered).to have_field(Event.human_attribute_name :name)
      expect(rendered).to have_field(Event.human_attribute_name :description)
      expect(rendered).to have_select(Event.human_attribute_name :game_mode)
      expect(rendered).to have_select(Event.human_attribute_name :player_type)
      expect(rendered).to have_field(Event.human_attribute_name :max_teams)
      expect(rendered).to have_field(Event.human_attribute_name :discipline)
      expect(rendered).to have_field(Event.human_attribute_name :deadline)
      expect(rendered).to have_field(Event.human_attribute_name :startdate)
      expect(rendered).to have_field(Event.human_attribute_name :enddate)
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

      expect(rendered).to have_field(Event.human_attribute_name :name)
      expect(rendered).to have_field(Event.human_attribute_name :description)
      expect(rendered).to have_select(Event.human_attribute_name :game_mode)
      expect(rendered).to have_select(Event.human_attribute_name :player_type)
      expect(rendered).to have_field(Event.human_attribute_name :max_teams)
      expect(rendered).to have_field(Event.human_attribute_name :discipline)
      expect(rendered).to have_field(Event.human_attribute_name :deadline)
      expect(rendered).to have_field(Event.human_attribute_name :startdate)
      expect(rendered).to have_field(Event.human_attribute_name :enddate)
    end
  end
end

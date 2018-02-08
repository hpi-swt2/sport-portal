require 'rails_helper'
require 'views/events/form_examples'

RSpec.describe 'events/new', type: :view do

  context 'new league' do
    before(:each) do
      assign(:event, FactoryBot.build(:league))
    end

    it_should_behave_like 'an event form', for_class: League, with: [:game_mode, :dates, :capacity, :gameday_duration, :selection, :player_type]
  end

  context 'new tournament' do
    before(:each) do
      assign(:event, FactoryBot.build(:tournament))
    end

    it_should_behave_like 'an event form', for_class: Tournament, with: [:dates, :capacity, :selection, :player_type]
  end

  context 'new rankinglist' do
    before(:each) do
      assign(:event, FactoryBot.build(:rankinglist))
    end

    it_should_behave_like 'an event form', for_class: Rankinglist, with: [:game_mode]
  end

  context 'event page' do
    before(:each) do
      assign(:event, FactoryBot.build(:rankinglist))
    end

    it "should display templates as tiles" do
      # FIXME find a way to identify the templates
      #
      # visit new_event_path(nil)
      # render
      #
      # expect(rendered).to have_css('div', class: 'tile')
    end

  end
end

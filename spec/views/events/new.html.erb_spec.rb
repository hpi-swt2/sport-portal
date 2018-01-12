require 'rails_helper'
require 'views/events/form_examples'

RSpec.describe 'events/new', type: :view do

  context 'new league' do
    before(:each) do
      assign(:event, FactoryBot.build(:league))
    end

    it_should_behave_like 'an event form', for_class: League, with: [:dates, :capacity, :gameday_duration]
  end

  context 'new tournament' do
    before(:each) do
      assign(:event, FactoryBot.build(:tournament))
    end

    it_should_behave_like 'an event form', for_class: Tournament, with: [:dates, :capacity]
  end

  context 'new rankinglist' do
    before(:each) do
      assign(:event, FactoryBot.build(:rankinglist))
    end

    it_should_behave_like 'an event form', for_class: Rankinglist
  end
end

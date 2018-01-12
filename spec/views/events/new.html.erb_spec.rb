require 'rails_helper'

RSpec.describe 'events/new', type: :view do
  # This set of shared examples provides a configurable way to test event creation forms
  shared_examples 'an event creation form' do |for_class: Event, with: []|
    it 'should render the events form' do
      render
      expect(rendered).to have_css("form[action='/#{for_class.name.pluralize.downcase}'][method='post']", count: 1)
    end

    it 'has input for default attributes' do
      render

      expect(rendered).to have_field(Event.human_attribute_name :name)
      expect(rendered).to have_field(Event.human_attribute_name :description)
      expect(rendered).to have_field(Event.human_attribute_name :game_mode)
      expect(rendered).to have_field(Event.human_attribute_name :discipline)
    end

    if with.include? :dates
      it 'has input for dates' do
        render

        expect(rendered).to have_field(Event.human_attribute_name :deadline)
        expect(rendered).to have_field(Event.human_attribute_name :startdate)
        expect(rendered).to have_field(Event.human_attribute_name :enddate)
      end
    end

    if with.include? :capacity
      it 'has input for capacity' do
        render

        expect(rendered).to have_field(Event.human_attribute_name :max_teams)
      end
    end

    if with.include? :selection
      it 'has input for selection type' do
        render

        expect(rendered).to have_field(Event.human_attribute_name :selection_type)
      end
    end
  end

  context 'new league' do
    before(:each) do
      assign(:event, FactoryBot.build(:league))
    end

    it_should_behave_like 'an event creation form', for_class: League, with: [:dates, :capacity, :selection]
  end

  context 'new tournament' do
    before(:each) do
      assign(:event, FactoryBot.build(:tournament))
    end

    it_should_behave_like 'an event creation form', for_class: Tournament, with: [:dates, :capacity, :selection]
  end

  context 'new rankinglist' do
    before(:each) do
      assign(:event, FactoryBot.build(:rankinglist))
    end

    it_should_behave_like 'an event creation form', for_class: Rankinglist
  end
end

require 'rails_helper'

# This set of shared examples provides a configurable way to test event creation and edit forms
shared_examples 'an event form' do |for_class: Event, path: :new, with: []|

  if path == :edit
    it 'should render the edit events form' do
      render
      expect(rendered).to have_css("form[action='/#{for_class.name.pluralize.downcase}/#{@event.id}'][method='post']", count: 1)
    end
  elsif path == :new
    it 'should render the new events form' do
      render
      expect(rendered).to have_css("form[action='/#{for_class.name.pluralize.downcase}'][method='post']", count: 1)
    end
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

  if with.include? :player_type
    it 'has input for player_type' do
      render

      expect(rendered).to have_field(Event.human_attribute_name :player_type)
    end

    it 'has default input for player_type field' do
      render

      if path == :edit
        expect(rendered).to have_field(Event.human_attribute_name :player_type, with: t(Event.human_player_type(@event.player_type)))
      elsif path == :new
        expect(rendered).to have_field(Event.human_attribute_name :player_type, with: t('events.new.select_player_type'))
      end
    end
  end

  if with.include? :capacity
    it 'has input for capacity' do
      render

      expect(rendered).to have_field(Event.human_attribute_name :max_teams)
    end
  end

  if with.include? :gameday_duration
    it 'has input for gameday duration' do
      render

      expect(rendered).to have_field(Event.human_attribute_name :gameday_duration)
    end
  end

  if with.include? :selection
    it 'has input for selection type' do
      render

      expect(rendered).to have_field(Event.human_attribute_name :selection_type)
    end
  end
end

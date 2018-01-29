require 'rails_helper'

RSpec.describe "events/show", type: :view do

  shared_examples "an event" do
    it "renders a name" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :name)
      expect(rendered).to have_content(@event.name)
    end
    it "renders a description" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :description)
      expect(rendered).to have_content(@event.description)
    end

    it "renders a description" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :discipline)
      expect(rendered).to have_content(@event.discipline)
    end

    it "renders a maximum number of teams" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :max_teams)
      expect(rendered).to have_content(@event.max_teams)
    end

    it "renders a game mode" do
      render
      expect(rendered).to have_content(@event.human_game_mode) #base class event does not have a game mode
    end


    #not signed in user
    it "doesn't render the new button when not signed in" do
      render
      expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.new'))
    end

    it "doesn't render the edit button when not signed in" do
      render
      expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
    end

    it "doesn't render the delete button when not signed in" do
      render
      expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
    end

    it "doesn't render the edit button when the event doesn´t belong to the user" do
      sign_in @other_user
      render
      expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
    end

    it "does render the edit button when the user is an admin" do
      sign_in @admin
      render
      expect(rendered).to have_selector(:link_or_button, t('helpers.links.edit'))
    end

    it "does render the delete button when the user is an admin" do
      sign_in @admin
      render
      expect(rendered).to have_selector(:link_or_button, t('helpers.links.destroy'))
    end

    it "doesn't render the delete button when the event doesn´t belong to the user" do
      sign_in @other_user
      render
      expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
    end

    it 'has a ranking button' do
      render
      expect(rendered).to have_content(t('events.show.to_ranking'))
    end
  end

  shared_examples "a time-restricted multiplayer event" do
    it "renders a game mode field" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :game_mode)
    end

    it "renders a start date" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :startdate)
      expect(rendered).to have_content(@event.startdate)
    end

    it "renders an end date" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :enddate)
      expect(rendered).to have_content(@event.enddate)
    end

    it "renders a deadline" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :deadline)
      expect(rendered).to have_content(@event.deadline)
    end
  end
  before(:each) do
    @user = FactoryBot.create :user
    @other_user = FactoryBot.create :user
    @admin = FactoryBot.create :admin
  end

  describe "League" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:league))
      @event.editors << @user
      @event.owner = @user
    end


    it "renders a schedule button" do
      render
      expect(rendered).to have_selector(:link_or_button, t('events.show.to_schedule'))
    end

    it "doesn't an overview button" do
      render
      expect(rendered).not_to have_selector(:link_or_button, t('events.show.to_overview'))
    end

    it "renders the gameday duration" do
      render
      expect(rendered).to have_content Event.human_attribute_name :gameday_duration
      expect(rendered).to have_content @event.gameday_duration
    end

    include_examples "an event"
    include_examples "a time-restricted multiplayer event"
  end


  describe "Tournament" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:tournament))
      @event.editors << @user
      @event.owner = @user
    end

    it "renders a schedule button" do
      render
      expect(rendered).to have_selector(:link_or_button, t('events.show.to_schedule'))
    end

    it "renders an overview button" do
      render
      expect(rendered).to have_selector(:link_or_button, t('events.show.to_overview'))
    end

    include_examples "an event"
    include_examples "a time-restricted multiplayer event"
  end

  describe "Rankinglist" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:rankinglist))
      @event.editors << @user
      @event.owner = @user
    end

    it "renders a metric field" do
      render
      expect(rendered).to have_content(Event.human_attribute_name :metric)
    end

    it "does not render a start date field" do
      render
      expect(rendered).not_to have_content(Event.human_attribute_name :startdate)
    end

    it "does not render an end date field" do
      render
      expect(rendered).not_to have_content(Event.human_attribute_name :enddate)
    end

    it "does not render a deadline field" do
      render
      expect(rendered).not_to have_content(Event.human_attribute_name :deadline)
    end

    it "doesn't render a schedule button" do
      render
      expect(rendered).to_not have_selector(:link_or_button, t('events.show.to_schedule'))
    end

    it "doesn't render an overview button" do
      render
      expect(rendered).to_not have_selector(:link_or_button, t('events.show.to_overview'))
    end

    include_examples "an event"
  end
end

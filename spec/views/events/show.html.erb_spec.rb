require 'rails_helper'

RSpec.describe "events/show", type: :view do

  shared_examples "an event" do
    it "renders attributes in <p>" do
      render
      expect(rendered).to have_content(@event.name)
      expect(rendered).to have_content(@event.description)
      expect(rendered).to have_content(@event.human_game_mode) #base class event does not have a game mode
      expect(rendered).to have_content(@event.discipline)
      expect(rendered).to have_content(@event.deadline)
      expect(rendered).to have_content(@event.startdate)
      expect(rendered).to have_content(@event.enddate)
    end

    it "renders an edit button for organizers" do
      render
    end

    it "renders styled buttons" do
      render
      expect(rendered).to have_content(t('events.show.to_overview'))
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

    it "doesn't render the delete button when the event doesn´t belong to the user" do
      sign_in @other_user
      render
      expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
    end
  end
  before(:each) do
    @user = FactoryBot.create :user
    @other_user = FactoryBot.create :user
  end

  describe "League" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:league))
      @event.editors << @user
      @event.owner = @user
    end
    it "has a schedule button" do
      render
      expect(rendered).to have_content(t('events.show.to_schedule'))
    end
    include_examples "an event"
  end


  describe "Tournament" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:tournament))
      @event.editors << @user
      @event.owner = @user
    end
    include_examples "an event"
  end

  describe "League" do
    before(:each) do
      @event = assign(:event, FactoryBot.create(:rankinglist))
      @event.editors << @user
      @event.owner = @user
    end
    include_examples "an event"
  end
end

require 'rails_helper'

describe "index event page", type: :feature do
  #Shared examples for feature event tests:
  shared_examples "a single player event" do
    context "which I participate in" do
      before(:each) do
        sign_in(@user)
        @event = event
        @event.add_participant(@user)
        visit events_path
      end

      it "should not have a join button" do
        expect(page).not_to have_link(:join_event_button)
      end
    end
  end


  shared_examples "a team event" do
    before(:each) do
      @event = event
      @team = team
      @team.members << @user
      sign_in @user
      visit events_path
    end

    context "which I do not participate in" do

      it "should not have a leave button" do
        expect(page).not_to have_link(:leave_event_button)
      end
    end

    context "which I participate in" do
      before(:each) do
        @event.add_team(@team)
        visit events_path
      end

      it "should not have a join button" do
        expect(page).not_to have_link(:join_event_button)
      end


      it "should show that I am participating in some events" do
        expect(page).to have_content I18n.t('events.index.my_events')
      end
    end
  end


  shared_examples "a past event" do
    before(:each) do
      @oldevent = event
    end



    it "should not display a join button" do
      sign_in @user
      visit events_path
      expect(page).not_to have_link(:join_event_button)
    end
  end

  before(:each) do
    @user = FactoryBot.create(:user)
  end

  context "for any event" do
    before(:each) do
      @event = FactoryBot.create :event
    end

    it "should not allow the user to join if they are not logged in" do
      visit events_path
      expect(page).not_to have_button(:join_event_button)
    end
  end

  context "for single player" do
    let(:player_type) { Event.player_types[:single] }
    before(:each) do
      sign_in @user
      visit events_path
    end

    describe "leagues" do
      let(:event) { FactoryBot.create(:league, player_type: player_type) }
      include_examples "a single player event"
    end

    describe "tournaments" do
      let(:event) { FactoryBot.create(:tournament, player_type: player_type) }
      include_examples "a single player event"
    end

    describe "rankinglists" do
      let(:event) { FactoryBot.create(:rankinglist) }
      include_examples "a single player event"
    end
  end

  context "for team" do
    let(:player_type) { Event.player_types[:team] }
    let(:team) { FactoryBot.create(:team) }

    describe "leagues" do
      let(:event) { FactoryBot.create(:league, player_type: player_type) }
      include_examples "a team event"
    end

    describe "tournaments" do
      let(:event) { FactoryBot.create(:tournament, player_type: player_type) }
      include_examples "a team event"
    end
  end

  context "for events whose deadline has passed" do
    describe "leagues" do
      let(:event) { FactoryBot.create(:league, deadline: Date.yesterday) }
      include_examples "a past event"
    end

    describe "Tournament" do
      let(:event) { FactoryBot.create(:tournament, deadline: Date.yesterday) }
      include_examples "a past event"
    end

  end
end

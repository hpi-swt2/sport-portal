require 'rails_helper'

describe "detailed event page", type: :feature do
  before(:each) do
    @user = FactoryBot.create :user
  end

  context "for any event" do
    before(:each) do
      @event = FactoryBot.create :event
    end

    it "should not have a join button if I am not logged in" do
      visit event_path(@event)
      expect(page).not_to have_link(:join_event_button)
    end
  end

  context "for single player events" do
    before(:each) do
      @event = FactoryBot.create :single_player_event
      sign_in @user
    end

    context "which I participate in" do
      before(:each) do
        @event.add_participant(@user)
        visit event_path(@event)
      end

      it "should have a leave button" do
        expect(page).to have_link(:leave_event_button)
      end

      it "should redirect me to itself when clicking the leave button" do
        click_link(:leave_event_button)
        expect(current_path).to eq(event_path(@event))
      end

      it "should not have a join button" do
        expect(page).not_to have_link(:join_event_button)
      end

      it "should show that I am participating" do
        expect(page).to have_content I18n.t('events.participating')
      end

      it "should have a join button after clicking the leave button" do
        click_link(:leave_event_button)
        expect(page).to have_link(:join_event_button)
      end
    end

    context "which I do not participate in" do
      before(:each) do
        visit event_path(@event)
      end

      it "should have a join button" do
        expect(page).to have_link(:join_event_button)
      end

      it "should redirect me to itself when clicking the join button" do
        click_link(:join_event_button)
        expect(current_path).to eq(event_path(@event))
      end

      it "should not have a leave button" do
        expect(page).not_to have_link(:leave_event_button)
      end

      it "should have a leave button after clicking the join button" do
        click_link(:join_event_button)
        expect(page).to have_link(:leave_event_button)
      end
    end
  end

  context "for team events" do
    before(:each) do
      @teamevent = FactoryBot.create :team_event
      sign_in @user
      visit event_path(@teamevent)
    end

    it "should not have a join button" do
      expect(page).not_to have_link(:join_event_button)
    end
  end
end

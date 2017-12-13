require 'rails_helper'

describe "index event page", type: :feature do
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

  context "for single player events" do
    before(:each) do
      @event = FactoryBot.create(:single_player_event)
      sign_in @user
      visit events_path
    end

    context "which I participate in" do
      before(:each) do
        @event.add_participant(@user)
        visit events_path
      end

      it "should not have a join button" do
        expect(page).not_to have_link(:join_event_button)
      end

      it "should redirect me to itself when clicking the leave button" do
        click_link(:leave_event_button)
        expect(current_path).to eq(events_path)
      end

      it "should have a leave button" do
        expect(page).to have_link(:leave_event_button)
      end

      it "should show that I am participating" do
        expect(page).to have_content I18n.t('events.participating')
      end

      it "should let me join again after clicking the leave button" do
        click_link(:leave_event_button)
        expect(page).to have_link(:join_event_button)
      end
    end

    context "which I do not participate in" do
      it "should have a join button" do
        expect(page).to have_link(:join_event_button)
      end

      it "should redirect me to itself when clicking the join button" do
        expect(current_path).to eq(events_path)
      end

      it "should let me leave after clicking the join button" do
        click_link(:join_event_button)
        expect(page).to have_link(:leave_event_button)
      end

      it "should not have a leave button" do
        expect(page).not_to have_link(:leave_event_button)
      end
    end
  end

  context "for team events" do
    before(:each) do
      @event = FactoryBot.create(:team_event)
      @team = FactoryBot.create(:team, :with_five_members)
      @team.members << @user
      sign_in @user
      visit events_path
    end

    context "which I do not participate in" do
      it "should have a join button" do
        expect(page).to have_link(:join_event_button)
      end

      #it "should render the team_join modal when clicking the join button" do
      pending "Add corresponding test for modal-testing here"
      #end

      #it "should let me leave after clicking the join button" do
      pending "Add corresponding test for button-testing inside the modal here"
      #end

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

      it "should have a leave button" do
        expect(page).to have_link(:leave_event_button)
      end

      it "should show that I am participating" do
        expect(page).to have_content I18n.t('events.participating')
      end

      context "with a team I own" do
        before(:each) do
          @team.owners << @user
          visit events_path
        end

        it "should have a clickable leave button" do
          leave_button = page.find_link(:leave_event_button)
          expect(leave_button[:disabled]).to eq nil
        end

        it "should redirect me to itself when clicking the leave button" do
          click_link(:leave_event_button)
          expect(current_path).to eq(events_path)
        end

        it "should let me join again after clicking the leave button" do
          click_link(:leave_event_button)
          expect(page).to have_link(:join_event_button)
        end
      end

      context "with a team I don't own" do
        it "should have a leave button that is disabled" do
          leave_button = page.find_link(:leave_event_button)
          expect(leave_button[:disabled]).to eq 'disabled'
        end
      end
    end
  end

  context "for events whose deadline has passed" do
    before(:each) do
      @oldevent = FactoryBot.create :event, deadline: Date.yesterday
    end

    it "should show them if the corresponding checkbox is enabled" do
      visit "/events?showAll=on"
      expect(page).to have_content(@oldevent.deadline.to_s)
    end

    it "should hide them if the corresponding checkbox is disabled" do
      visit events_path
      expect(page).not_to have_content(@oldevent.deadline.to_s)
    end

    it "should not display a join button" do
      sign_in @user
      visit "/events?showAll=on"
      expect(page).not_to have_link(:join_event_button)
    end
  end
end

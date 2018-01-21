require 'rails_helper'

# Shared examples for show event page


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

    it "should display an image" do
      visit event_path(@event)
      expect(page).to have_css("img[src='#{@event.image_url}']")
    end
  end

  shared_examples "a single player event" do
    before(:each) do
      sign_in @user
      @event = event
    end

    context "participants" do
      before(:each) do
        @event.add_participant @user
        visit event_path(@event)
      end

      it "should show a list of participants" do
        expect(page).to have_content I18n.t('events.show.participants')
      end

      it "should show name of joined users" do
        expect(page).to have_content @user.name
      end
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
        @event = event
      end

      context "fcfs event" do
        before(:each) do
          @event.selection_type = Event.selection_types[:fcfs]
          @event.max_teams = 1
          visit event_path(@event)
          @event = event
        end

        it "should have right selection type" do
          expect(@event.human_selection_type).to eq(I18n.t('events.fcfs'))
        end

        it "should have a join button if not exceeding max teams" do
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

        context "full fcfs event" do
          before(:each) do
            event = FactoryBot.create(:event, max_teams: 0)
            visit event_path(event)
          end

          it "should be labeled as full if max teams is reached" do
            expect(page).to have_content(I18n.t('events.full'))
          end

          it "should not be able to join if max teams is reached" do
            expect(page).not_to have_link(:join_event_button)
          end
        end
      end


    end
  end

  shared_examples "a team event" do
    before(:each) do
      sign_in @user
      @team = team
      @team.members << @user
      @teamevent = event
      visit event_path(@teamevent)
    end

    context "which I do not participate in" do
      it "should have a join button" do
        expect(page).to have_link(:join_event_button)
      end

      it "should not have a leave button" do
        expect(page).not_to have_link(:leave_event_button)
      end
    end

    context "which I participate in" do
      before(:each) do
        @teamevent.add_team(@team)
        visit event_path(@teamevent)
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
          visit event_path(@teamevent)
        end

        it "should have a clickable leave button" do
          leave_button = page.find_link(:leave_event_button)
          expect(leave_button[:disabled]).to eq nil
        end

        it "should redirect me to itself when clicking the leave button" do
          click_link(:leave_event_button)
          expect(current_path).to eq(event_path(@teamevent))
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

    context "for events whose deadline has passed" do
      before(:each) do
        @oldevent = FactoryBot.create :event, deadline: Date.yesterday
        sign_in @user
        visit event_path(@oldevent)
      end

      it "should not display a join button" do
        expect(page).not_to have_link(:join_event_button)
      end
    end

    context "participants" do
      before(:each) do
        @team = FactoryBot.create :team
        @teamevent.teams << @team
        visit event_path(@teamevent)
      end

      it "should show a list of participating teams" do
        expect(page).to have_content I18n.t('events.show.participants')
      end

      it "should show name of joined teams" do
        expect(page).to have_link @team.name
      end
    end
  end

  context "for single player" do
    describe "Leagues" do
      let(:event) { FactoryBot.create(:league, owner_id: @user.id, player_type: Event.player_types[:single]) }
      include_examples "a single player event"
    end

    describe "Tournaments" do
      let(:event) { FactoryBot.create :tournament, owner_id: @user.id, player_type: Event.player_types[:single] }
      include_examples "a single player event"
    end

    describe "Rankinglist" do

      let(:event) { FactoryBot.create :rankinglist, owner_id: @user.id }
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
end

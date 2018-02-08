require 'rails_helper'
require 'features/event/show_event_examples'

describe 'detailed event page', type: :feature do

  let(:user) { FactoryBot.create :user }

  context 'for any event' do
    let(:event) { FactoryBot.create :event }

    it 'should not have a join button if I am not logged in' do
      visit event_path(event)
      expect(page).not_to have_link(:join_event_button)
    end
  end

  shared_examples 'a single player event' do

    let(:user) { FactoryBot.create :user }
    before :each do
      sign_in user
    end

    context 'participants' do
      before :each do
        event.add_participant user
        visit event_path(event)
      end

      it_behaves_like 'a show event page' do
        let(:with_content) { [I18n.t('events.show.participants'), user.name] }
      end
    end

    context 'which I participate in' do
      before :each do
        event.add_participant user
        visit event_path(event)
      end

      it_behaves_like 'a show event page', with: [:leave_button], without: [:join_button]
    end

    context 'which I do not participate in' do
      before(:each) do
        visit event_path(event)
      end

      context 'fcfs event' do
        before(:each) do
          event.selection_type = Event.selection_types[:fcfs]
          event.max_teams = 1
        end

        it 'should have right selection type' do
          expect(event.human_selection_type).to eq(I18n.t('events.fcfs'))
        end

        it_behaves_like 'a show event page', with: [:join_button], without: [:leave_button]

        context 'full fcfs event' do
          before(:each) do
            event = FactoryBot.create(:event, max_teams: 0)
            visit event_path(event)
          end

          it_behaves_like 'a show event page', without: [:join_button] do
            let(:with_content) { [I18n.t('events.full')] }
          end
        end
      end
    end
  end

  shared_examples 'a team event' do
    before(:each) do
      sign_in user
      team.members << user
      visit event_path(event)
    end

    context 'which I do not participate in' do
      it_behaves_like 'a show event page', with: [:team_join_button], without: [:leave_button]
    end

    context 'which I participate in' do
      before(:each) do
        event.add_team(team)
        visit event_path(event)
      end

      it_behaves_like 'a show event page', with: [:team_leave_button], without: [:join_button] do
        let(:with_content) { [I18n.t('events.participating')] }
      end

      context 'with a team I own' do
        before(:each) do
          team.owners << user
          visit event_path(event)
        end

        it_behaves_like 'a show event page', with: [:leave_button], without: [:join_button]
      end

      context "with a team I don't own" do
        it 'should have a leave button that is disabled' do
          leave_button = page.find_link(:leave_event_button)
          expect(leave_button[:disabled]).to eq 'disabled'
        end
      end
    end

    context 'for events whose deadline has passed' do
      let(:oldevent) { FactoryBot.create :event, deadline: Date.yesterday }
      before(:each) do
        visit event_path(oldevent)
      end
      it_behaves_like 'a show event page', without: [:join_button]
    end

    context 'participants' do
      let(:team) { FactoryBot.create :team }
      before(:each) do
        event.teams << team
        visit event_path(event)
      end

      it_should_behave_like 'a show event page' do
        let(:with_content) { [I18n.t('events.show.participants'), team.name] }
      end
    end
  end

  context 'for single player' do
    describe 'Leagues' do
      let(:event) { FactoryBot.create(:league, owner_id: user.id, player_type: Event.player_types[:single]) }
      include_examples 'a single player event'
    end

    describe 'Tournaments' do
      let(:event) { FactoryBot.create :tournament, owner_id: user.id, player_type: Event.player_types[:single] }
      include_examples 'a single player event'
    end

    describe 'Rankinglist' do

      let(:event) { FactoryBot.create :rankinglist, owner_id: user.id }
      include_examples 'a single player event'
    end
  end

  context 'for team' do
    let(:player_type) { Event.player_types[:team] }
    let(:team) { FactoryBot.create(:team) }

    describe 'leagues' do
      let(:event) { FactoryBot.create(:league, player_type: player_type) }
      include_examples 'a team event'
    end
    describe 'tournaments' do
      let(:event) { FactoryBot.create(:tournament, player_type: player_type) }
      include_examples 'a team event'
    end
  end
end
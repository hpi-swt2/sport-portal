require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do

  before(:context) do
    @user = FactoryBot.create(:user)
    @other_user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  after(:context) do
    @user.destroy
    @other_user.destroy
    @admin.destroy
  end

  describe 'User' do

    subject(:ability) { Ability.new(user) }

    describe 'when not logged in' do
      let(:user) { nil }

      describe 'for public teams' do
        let(:team) { FactoryBot.build :team }
        it { is_expected.to be_able_to(:read, team) }
        it { is_expected.to_not be_able_to(:send_emails_to_team_members, team) }
      end

      describe 'for private teams' do
        let(:team) { FactoryBot.create :team, :private }
        it { is_expected.to_not be_able_to(:read, team) }
      end
    end

    describe 'when logged in' do
      let(:user) { @user }

      describe 'for public teams' do
        let(:team) { FactoryBot.build :team }
        it { is_expected.to be_able_to(:read, team) }
        it { is_expected.to_not be_able_to(:send_emails_to_team_members, team) }
      end

      describe 'for private teams with two owners and five members' do
        let(:team) { FactoryBot.create :team, :private }
        it { is_expected.to_not be_able_to(:read, team) }

        describe 'when is a member' do
          let(:user) { team.members[0] }
          it { is_expected.to be_able_to(:read, team) }
          it { is_expected.to be_able_to(:assign_membership_by_email, team) }
          it { is_expected.to be_able_to(:send_emails_to_team_members, team) }
        end

        describe 'when is an owner' do
          let(:user) { team.owners[0] }
          it { is_expected.to be_able_to(:read, team) }
          it { is_expected.to be_able_to(:assign_membership_by_email, team) }
          it { is_expected.to be_able_to(:send_emails_to_team_members, team) }
        end
      end

      describe 'for events' do
        let(:event) { FactoryBot.build :event }
        it { is_expected.to be_able_to(:ranking, event) }
      end
    end
  end

  it 'should allow team owners to delete their ownership & membership having multiple team owners left' do
    ability = Ability.new(@user)
    team = FactoryBot.create :team, :private
    team.owners << @user

    expect(ability).to be_able_to(:delete_ownership, team, @user.id)
    expect(ability).to be_able_to(:delete_membership, team, @user.id)
  end

  describe 'when user is in private team' do
    before :each do
      @ability = Ability.new(@user)
      @team = FactoryBot.create :team, :private
    end

    it 'should not allow team owners to delete their ownership & membership having only one team owner left' do
      @team.owners = [@user]

      expect(@ability).to_not be_able_to(:delete_ownership, @team, @user.id)
      expect(@ability).to_not be_able_to(:delete_membership, @team, @user.id)
    end

    it 'should allow team owners to delete the ownership & membership of another team owner having multiple team owners left' do
      @team.owners = [@user, @other_user]

      expect(@ability).to be_able_to(:delete_ownership, @team, @other_user.id)
      expect(@ability).to be_able_to(:delete_membership, @team, @other_user.id)
    end

    it 'should allow team members to delete their ownership & membership having at least one team owner left' do
      @team.members << @user

      expect(@ability).to be_able_to(:delete_membership, @team, @user.id)
    end

    it 'should not allow team members to delete the ownership & membership of a team owner having only one team owner left' do
      @team.members = [@user, @other_user]
      @team.owners = [@other_user]

      expect(@ability).to_not be_able_to(:delete_ownership, @team, @other_user.id)
      expect(@ability).to_not be_able_to(:delete_membership, @team, @other_user.id)
    end
  end

  describe 'when there is an ability needed for the user' do
    before :each do
      @ability = Ability.new(@user)
    end
    it 'should be able to destroy a team as a team owner' do
      team = FactoryBot.create :team
      team.owners << @user

      expect(@ability).to be_able_to(:destroy, team)
    end

    it 'should be able to destroy a team as a team member' do
      team = FactoryBot.create :team
      team.members << @user

      expect(@ability).to_not be_able_to(:destroy, team)
    end

    it 'should not be able to destroy a team when participating in an event as a team owner' do
      team = FactoryBot.create :team
      team.owners << @user

      event = FactoryBot.create :event, :has_dates, :team_player
      event.teams << team

      expect(@ability).to_not be_able_to(:destroy, team)
    end

    it 'should allow users to modify their own user data' do
      expect(@ability).to be_able_to(:modify, @user)
    end

    it 'should not allow users to crud other users data' do
      expect(@ability).to_not be_able_to(:manage, @other_user)
    end

    it 'should allow users to view their user dashboard' do
      expect(@ability).to be_able_to(:dashboard, @user)
    end

    it "should not allow users to view other users' dashboard" do
      expect(@ability).to_not be_able_to(:dashboard, @other_user)
    end

    it 'should allow users to crud events they created' do
      event = Event.new(owner: @user)
      expect(@ability).to be_able_to([:create, :read, :update, :destroy], event)
    end

    it 'should not allow users to modify events they did not create' do
      event = Event.new
      expect(@ability).to_not be_able_to(:modify, event)
    end

    it 'should not allow users to crud teams they did not create' do
      team = Team.new
      expect(@ability).to_not be_able_to(:manage, team)
    end

    it 'should not allow users to invite user to teams they are no member of' do
      team = Team.new
      expect(@ability).to_not be_able_to(:assign_membership_by_email, team)
    end

  end


  it 'should be able to destroy a team as an admin' do
    ability = Ability.new(@admin)
    team = FactoryBot.create :team

    expect(ability).to be_able_to(:destroy, team)
  end

  it 'should be able to destroy a team when participating in an event as a admin' do
    ability = Ability.new(@admin)
    team = FactoryBot.create :team
    team.owners << @admin

    event = FactoryBot.create :event, :has_dates, :team_player
    event.teams << team

    expect(ability).to be_able_to(:destroy, team)
  end

  it 'should have admin permissions, if the user is admin' do
    ability = Ability.new(@admin)

    expect(ability).to be_able_to(:manage, :all)
  end



  it 'should allow admin to crud teams they did not create' do
    team = Team.new

    ability = Ability.new(@admin)
    expect(ability).to be_able_to(:manage, team)
    expect(ability).to be_able_to(:assign_membership_by_email, team)
  end

  shared_examples "a past event" do
    before(:each) do
      @ability = Ability.new(@user)
    end

    it 'should not allow users to join' do
      expect(@ability).not_to be_able_to(:join, event)
    end
  end

  shared_examples "a single player event" do
    before(:each) do
      @ability = Ability.new(@user)
    end

    it 'should not allow users to leave if they are not participating' do
      expect(@ability).not_to be_able_to(:leave, event)
    end
  end

  context "for time-restricted" do
    describe "leagues" do
      let(:event) { FactoryBot.create(:league, :passed_deadline) }
      include_examples "a past event"
    end

    describe "tournaments" do
      let(:event) { FactoryBot.create(:tournament, :passed_deadline) }
      include_examples "a past event"
    end
  end

  context "for single player" do
    describe "leagues" do
      let(:event) { FactoryBot.create(:league, :single_player) }
      let(:ability) { Ability.new(user) }
      include_examples "a single player event"

      describe 'gameday dates' do

        let(:event) { FactoryBot.create(:league, :single_player, :with_gameday, organizers: organizers) }
        let(:user) { @user }
        context 'when the user is not an organizer' do
          let(:organizers) { Array.new }
          it 'should not allow to be changed' do
            expect(ability).not_to be_able_to(:update, event.gamedays.first)
          end
        end

        context 'when the user is an organizer' do
          let(:organizers) { [Organizer.new(user: @user)] }
          let(:user) { @user.organizers << organizers
                       @user }
          it 'should allow to be changed' do
            expect(ability).to be_able_to(:update, event.gamedays.first)
          end
        end
      end
    end

    describe "tournaments" do
      let(:event) { FactoryBot.create(:tournament, :single_player) }
      include_examples "a single player event"
    end

    describe "rankinglists" do
      let(:event) { FactoryBot.create(:rankinglist, :single_player) }
      include_examples "a single player event"
    end
  end

  describe 'teams with max and min players' do
    before :each do
      @ability = Ability.new(@user)
      @team = FactoryBot.create :team, :private, :with_five_members
      @event = FactoryBot.create :event
      @team.members << @user
    end

    it 'should allow to reduce the size of a team if the min players per team requirement of any event the team is in is still met afterwards.' do
      @event.min_players_per_team = 5
      @event.max_players_per_team = 6
      @team.events << @event

      expect(@ability).to be_able_to(:delete_membership, @team, @user.id)
    end

    it 'should allow to increase the size of a team if the max players per team requirement of any event the team is in is still met afterwards.' do
      @event.min_players_per_team = 6
      @event.max_players_per_team = 7
      @team.events << @event

      expect(@ability).to be_able_to(:assign_membership_by_email, @team, @other_user.id)
    end

    it 'should not allow to reduce the size of a team so that the size is smaller than the min players per team requirement of any event the team is in.' do
      @event.min_players_per_team = 6
      @event.max_players_per_team = 6
      @team.events << @event

      expect(@ability).to_not be_able_to(:delete_membership, @team, @user.id)
    end

    it 'should not allow to increase the size of a team so that the size is bigger than the max players per team requirement of any event the team is in.' do
      @event.min_players_per_team = 6
      @event.max_players_per_team = 6
      @team.events << @event

      expect(@ability).to_not be_able_to(:assign_membership_by_email, @team, @other_user.id)
    end
  end
end

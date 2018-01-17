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

  it 'should not allow team owners to delete their ownership & membership having only one team owner left' do
    ability = Ability.new(@user)
    team = FactoryBot.create :team, :private
    team.owners = [@user]

    expect(ability).to_not be_able_to(:delete_ownership, team, @user.id)
    expect(ability).to_not be_able_to(:delete_membership, team, @user.id)
  end

  it 'should allow team owners to delete the ownership & membership of onother team owner having multiple team owners left' do
    ability = Ability.new(@user)
    team = FactoryBot.create :team, :private
    team.owners = [@user, @other_user]

    expect(ability).to be_able_to(:delete_ownership, team, @other_user.id)
    expect(ability).to be_able_to(:delete_membership, team, @other_user.id)
  end

  it 'should allow team members to delete their ownership & membership having at least one team owner left' do
    ability = Ability.new(@user)
    team = FactoryBot.create :team, :private
    team.members << @user

    expect(ability).to be_able_to(:delete_membership, team, @user.id)
  end

  it 'should not allow team members to delete the ownership & membership of a team owner having only one team owner left' do
    ability = Ability.new(@user)
    team = FactoryBot.create :team, :private
    team.members = [@user, @other_user]
    team.owners = [@other_user]

    expect(ability).to_not be_able_to(:delete_ownership, team, @other_user.id)
    expect(ability).to_not be_able_to(:delete_membership, team, @other_user.id)
  end

  it 'should have admin permissions, if the user is admin' do
    ability = Ability.new(@admin)

    expect(ability).to be_able_to(:manage, :all)
  end

  it 'should allow users to modify their own user data' do
    ability = Ability.new(@user)

    expect(ability).to be_able_to(:modify, @user)
  end

  it 'should not allow users to crud other users data' do
    ability = Ability.new(@user)

    expect(ability).to_not be_able_to(:manage, @other_user)
  end

  it 'should allow users to view their user dashboard' do
    ability = Ability.new(@user)

    expect(ability).to be_able_to(:dashboard, @user)
  end

  it "should not allow users to view other users' dashboard" do
    ability = Ability.new(@user)

    expect(ability).to_not be_able_to(:dashboard, @other_user)
  end

  it 'should allow users to crud events they created' do
    event = Event.new(owner: @user)
    ability = Ability.new(@user)
    expect(ability).to be_able_to([:create, :read, :update, :destroy], event)
  end

  it 'should not allow users to modify events they did not create' do
    event = Event.new

    ability = Ability.new(@user)
    expect(ability).to_not be_able_to(:modify, event)
  end


  it 'should allow admin to crud teams they did not create' do
    team = Team.new

    ability = Ability.new(@admin)
    expect(ability).to be_able_to(:manage, team)
    expect(ability).to be_able_to(:assign_membership_by_email, team)
  end

  it 'should not allow users to crud teams they did not create' do
    team = Team.new

    ability = Ability.new(@user)
    expect(ability).to_not be_able_to(:manage, team)
  end

  it 'should not allow users to invite user to teams they are no member of' do
    team = Team.new

    ability = Ability.new(@user)
    expect(ability).to_not be_able_to(:assign_membership_by_email, team)
  end

  # If Event Ability tests become bigger than these 5 examples, consider using shared examples like done in the
  # feature tests for index_event_spec and show_event_spec. Hardcoding for 5 cases doesn't seem too bad
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
      include_examples "a single player event"
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
end

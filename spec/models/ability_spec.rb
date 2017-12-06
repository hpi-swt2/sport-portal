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
      end

      describe 'for private teams' do
        let(:team) { FactoryBot.create :team, :private, :with_five_members, :with_two_owners }
        it { is_expected.to_not be_able_to(:read, team) }

        context 'when is a member' do
          let(:user) { team.members[0] }
          it { is_expected.to be_able_to(:read, team) }
        end

        context 'when is an owner' do
          let(:user) { team.owners[0] }
          it { is_expected.to be_able_to(:read, team) }
        end
      end
    end
  end

  it 'should have admin permissions, if the user is admin' do
    ability = Ability.new(@admin)

    ability.should be_able_to(:manage, :all)
  end

  it 'should allow users to modify their own user data' do
    ability = Ability.new(@user)

    ability.should be_able_to(:modify, @user)
  end

  it 'should not allow users to crud other users data' do
    ability = Ability.new(@user)

    ability.should_not be_able_to(:manage, @other_user)
  end

  it 'should allow users to crud events they created' do
    event = Event.new(owner: @user)
    ability = Ability.new(@user)
    ability.should be_able_to(:crud, event)
  end

  it 'should not allow users to modify events they did not create' do
    event = Event.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:modify, event)
  end


  it 'should allow admin to crud teams they did not create' do
    team = Team.new()

    ability = Ability.new(@admin)
    ability.should be_able_to(:manage, team)
  end

  it 'should not allow users to crud teams they did not create' do
    team = Team.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:manage, team)
  end

  it 'should not allow users to join events after their deadline has passed' do
    event = FactoryBot.create :passed_deadline_event
    ability = Ability.new(@user)
    expect(ability).not_to be_able_to(:join, event)
  end

  it 'should not allow users to leave events they are not participating in' do
    event = FactoryBot.create :single_player_event
    ability = Ability.new(@user)
    expect(ability).not_to be_able_to(:leave, event)
  end
end

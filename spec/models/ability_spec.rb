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
          it { is_expected.to be_able_to(:assign_membership_by_email, team) }
        end

        context 'when is an owner' do
          let(:user) { team.owners[0] }
          it { is_expected.to be_able_to(:read, team) }
          it { is_expected.to be_able_to(:assign_membership_by_email, team) }
        end
      end
    end
  end

  it 'should have admin permissions, if the user is admin' do
    ability = Ability.new(@admin)

    ability.should be_able_to(:manage, :all)
  end

  it 'should allow users to manage their own user data' do
    ability = Ability.new(@user)

    ability.should be_able_to(:manage, @user)
  end

  it 'should not allow users to crud other users data' do
    ability = Ability.new(@user)

    ability.should_not be_able_to(:manage, @other_user)
  end

  it 'should allow users to crud events they created' do
    event = Event.new(owner: @user)
    ability = Ability.new(@user)
    ability.should be_able_to(:manage, event)
  end

  it 'should not allow users to crud events they did not create' do
    event = Event.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:manage, event)
  end


  it 'should allow admin to crud teams they did not create' do
    team = Team.new()

    ability = Ability.new(@admin)
    ability.should be_able_to(:manage, team)
    expect(ability).to be_able_to(:assign_membership_by_email, team)
  end

  it 'should not allow users to crud teams they did not create' do
    team = Team.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:manage, team)
  end

  it 'should not allow users to invite user to teams they are no member of' do
    team = Team.new

    ability = Ability.new(@user)
    ability.should_not be_able_to(:assign_membership_by_email, team)
  end
end

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    subject(:ability) { Ability.new(user) }

    describe 'when not logged in' do
      let(:user){ nil }

      describe 'for public teams' do
        let(:team){ FactoryBot.create :team }
        it { is_expected.to be_able_to(:read, team) }
      end

      describe 'for private teams' do
        let(:team){ FactoryBot.create :team, :private }
        it { is_expected.to_not be_able_to(:read, team) }
      end
    end

    describe 'when logged in' do
      let(:user){ FactoryBot.create :user }

      describe 'for public teams' do
        let(:team){ FactoryBot.create :team }
        it { is_expected.to be_able_to(:read, team) }
      end

      describe 'for private teams' do
        let(:team){ FactoryBot.create :team, :private, :with_owners, :with_members }
        it { is_expected.to_not be_able_to(:read, team) }

        context 'when is a member' do
          let(:user){ team.members[0] }
          it { is_expected.to be_able_to(:read, team) }
        end

        context 'when is an owner' do
          let(:user){ team.owners[0] }
          it { is_expected.to be_able_to(:read, team) }
        end
      end
    end
  end
end

require 'rails_helper'
require 'cancan/matchers'

RSpec.describe Ability, type: :model do
  describe 'User' do
    describe 'abilities' do
      subject(:ability) { Ability.new(user) }
      let(:user){ nil }

      describe 'for public teams' do
        let(:team){ FactoryBot.create :team }
        let(:user){ FactoryBot.create :user }
        it { is_expected.to be_able_to(:read, team) }
      end

      describe 'for private teams' do
        describe 'without members' do
          let(:team){ FactoryBot.create :team, :private }
          let(:user){ FactoryBot.create :user }
          it { is_expected.to_not be_able_to(:read, team) }
        end
        describe 'with members' do
          let(:team){ FactoryBot.create :team, :private, :with_members }

          context 'when is not a member' do
            let(:user){ FactoryBot.create :user }
            it { is_expected.to_not be_able_to(:read, team) }
          end

          context 'when is a member' do
            let(:user){ team.members[0] }
            it { is_expected.to be_able_to(:read, team) }
          end
        end
        describe 'with owners' do
          let(:team){ FactoryBot.create :team, :private, :with_owners }

          context 'when is not an owner' do
            let(:user){ FactoryBot.create :user }
            it { is_expected.to_not be_able_to(:read, team) }
          end

          context 'when is an owner' do
            let(:user){ team.owners[0] }
            it { is_expected.to be_able_to(:read, team) }
          end
        end
      end
    end
  end
end

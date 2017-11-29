require 'rails_helper'

RSpec.describe TeamMember, type: :model do

  describe 'when logged in' do
    let(:user){ FactoryBot.create :user }
    let(:team){ FactoryBot.create :team }

    it "should not be able to assign team ownership to users and delete it" do
      ability = Ability.new(user)
      assert ability.cannot?(:assign_ownership, team)
    end

    it "should not be able to delete team ownership" do
      ability = Ability.new(user)

      assert ability.cannot?(:delete_ownership, team)
    end

    it "should not be able to delete team membership of other users" do
      another_user = FactoryBot.create :user
      team.members << user
      team.members << another_user

      ability = Ability.new(another_user, user.id)

      assert ability.cannot?(:delete_membership, team)
    end

    it "should be able to delete himself from team" do
      another_user = FactoryBot.create :user
      team.owners << another_user

      ability = Ability.new(user, user.id)

      assert ability.can?(:delete_membership, team)
    end
  end
end

require 'rails_helper'

RSpec.describe TeamUser, type: :model do
  describe 'when logged in' do
    let(:user) { FactoryBot.create :user }
    let(:team) { FactoryBot.create :team }

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

      ability = Ability.new(user, another_user.id)

      assert ability.cannot?(:delete_membership, team)
    end

    it "should be able to delete himself from team" do
      ability = Ability.new(user, user.id)
      assert ability.can?(:delete_membership, team)
    end

    it "should be able to assign team ownership to users and delete it" do
      ability = Ability.new(user)
      team.owners << user
      assert ability.can?(:assign_ownership, team)
    end

    it "should be not be able to delete his own ownership if he is the only owner" do
      user = team.owners.first
      ability = Ability.new(user)
      assert ability.cannot?(:delete_ownership, team)
    end

    it "should be able to delete members from team" do
      another_user = FactoryBot.create :user
      team.members << another_user
      ability = Ability.new(user, another_user.id)
      team.owners << user
      assert ability.can?(:delete_membership, team)
    end

    it "should not be able to delete himself from team if he's the only owner" do
      user = team.owners.first
      ability = Ability.new(user, user.id)
      assert ability.cannot?(:delete_membership, team)
    end
  end
end

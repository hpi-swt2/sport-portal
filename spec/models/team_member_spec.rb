require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  it "should not be able to assign team ownership to users and delete it" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user

    ability = Ability.new(user)

    assert ability.cannot?(:assign_ownership, team)
  end

  it "should not be able to delete team ownership" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user

    ability = Ability.new(user)

    assert ability.cannot?(:delete_ownership, team)
  end

  it "should not be able to delete team membership of other users" do
    team = FactoryBot.create :team

    user = FactoryBot.create :user
    another_user = FactoryBot.create :user
    team.members << user
    team.members << another_user

    ability = Ability.new(another_user, user.id)

    assert ability.cannot?(:delete_membership, team)
  end
p
  it "should be able to delete himself from team" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user
    another_user = FactoryBot.create :user
    team.owners << another_user

    ability = Ability.new(user, user.id)

    assert ability.can?(:delete_membership, team)
  end
end

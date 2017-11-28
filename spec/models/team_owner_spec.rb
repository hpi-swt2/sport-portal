require 'rails_helper'

RSpec.describe TeamOwner, type: :model do
  it "should be able to assign team ownership to users and delete it" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user
    another_user = FactoryBot.create :user


    ability = Ability.new(user)

    team.owners << user
    team.owners << another_user

    assert ability.can?(:assign_ownership, team)
  end

  it "should be not be able to delete his own ownership if he is the only owner" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user
    another_user = FactoryBot.create :user


    ability = Ability.new(user)

    assert ability.cannot?(:delete_ownership, team)
  end

  it "should be able to delete members from team" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user
    another_user = FactoryBot.create :user


    ability = Ability.new(user, another_user.id)

    team.owners << user

    assert ability.can?(:delete_membership, team)
  end

  it "should not be able to delete himself from team if he's the only owner" do
    team = FactoryBot.create :team
    user = team.owners.first
    ability = Ability.new(user, user.id)

    assert ability.cannot?(:delete_membership, team)
  end
end

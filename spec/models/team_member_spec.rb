require 'rails_helper'

RSpec.describe TeamMember, type: :model do
  it "should not be able to assign team ownership to users and delete it" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user

    ability = Ability.new(user)

    assert ability.cannot?(:assign_ownership, team)
  end

  it "should not be able to delete team ownership to users and delete it" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user

    ability = Ability.new(user)

    assert ability.cannot?(:delete_ownership, team)
  end
end

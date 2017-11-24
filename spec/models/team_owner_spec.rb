require 'rails_helper'

RSpec.describe TeamOwner, type: :model do
  it "should be able to assign team ownership to users" do
    team = FactoryBot.create :team
    user = FactoryBot.create :user

    ability = Ability.new(user)

    team.owners << user

    assert ability.can?(:assign_ownership, team)
  end
end

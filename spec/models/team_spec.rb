# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid when produced by a factory" do
    team = FactoryBot.create :team
    expect(team).to be_valid
  end

  it "should have and belong to team owners" do
    team = FactoryBot.create :team
    # After building a team via FactoryBot an owner is created using the factory for users and assigned to the team
    expect(team.owners).to have(1).items
  end

  it "should have and belong to team members" do
    # After building a team via FactoryBot a member is created using the factory for users and assigned to the team
    team = FactoryBot.create :team
    expect(team.members).to have(1).items
  end

  it "should be able to have multiple team owners" do
    team = FactoryBot.create :team, :with_multiple_owners
    expect(team.team_owners).to have(2).items
    expect(team.owners).to have(2).items
    expect(team.team_members).to have(2).items
    expect(team.members).to have(2).items
  end

  it "should be able to have multiple team members" do
    team = FactoryBot.create :team, :with_multiple_members
    expect(team.team_members).to have(5).items
    expect(team.members).to have(5).items
  end

end

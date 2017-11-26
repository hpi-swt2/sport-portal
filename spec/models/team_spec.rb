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
    expect(team.owners).to eq([])
  end

  it "should have and belong to team members" do
    team = FactoryBot.create :team
    expect(team.members).to eq([])
  end

  it "should be able to have team owners" do
    team = FactoryBot.create :team, :with_owners
    expect(team.team_owners).to have(2).items
    expect(team.owners).to have(2).items
    expect(team.team_members).to have(2).items
    expect(team.members).to have(2).items
  end

  it "should be able to have team members" do
    team = FactoryBot.create :team, :with_members
    expect(team.team_members).to have(5).items
    expect(team.members).to have(5).items
  end

end

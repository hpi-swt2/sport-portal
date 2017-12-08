# == Schema Information
#
# Table name: teams
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text
#  kind_of_sport :string
#  private       :boolean
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid when produced by a factory" do
    team = FactoryBot.build :team
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

  describe '#matches' do
    it 'should return all matches of the team' do
      team = FactoryBot.create(:team)
      expect(team.matches).to be_empty
      match_a = FactoryBot.create(:match)
      match_b = FactoryBot.create(:match)
      match_a.team_home = team
      match_b.team_away = team
      match_a.save
      match_b.save
      team.reload
      expect(team.home_matches).to contain_exactly(match_a)
      expect(team.away_matches).to contain_exactly(match_b)
      expect(team.matches).to contain_exactly(match_a, match_b)
    end
  end

  it "should be able to have multiple team owners" do
    team = FactoryBot.create :team, :with_two_owners
    expect(team.owners).to have(2).items
    expect(team.members).to have(2).items
  end

  it "should be able to have multiple team members" do
    team = FactoryBot.create :team, :with_five_members
    expect(team.members).to have_at_least(5).items
  end

end

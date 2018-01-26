require 'rails_helper'

describe 'Participant model', type: :model do

  let(:event) { FactoryBot.build(:event) }
  let(:match) { FactoryBot.build(:match, :with_results) }

  it "calculates the number of wins in an event" do
    event = FactoryBot.create :event
    team = FactoryBot.create :team
    another_team = FactoryBot.create :team
    match = FactoryBot.create(:match, event_id: event.id)
    FactoryBot.create(:game_result,score_home: 2, score_away: 1 ,match_id: match.id)
    puts match.team_home_id
    winning_team = event.participants.where("team_id = ?", match.winner.id)
    puts winning_team.id
    expect(winning_team.number_of_wins).to eq(1)
  end
end
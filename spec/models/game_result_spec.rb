# == Schema Information
#
# Table name: game_results
#
#  id                    :integer          not null, primary key
#  score_home            :integer
#  score_away            :integer
#  match_id              :integer
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  scores_proposed_by_id :integer
#

require 'rails_helper'

RSpec.describe GameResult, type: :model do
  it "is valid when produced by a factory" do
    expect(FactoryBot.build(:game_result)).to be_valid
  end

  it "fails validation with non-number scores" do
    result = FactoryBot.build(:game_result, score_home: "2a")

    expect { result.valid? }.to change { result.errors[:score_home].count }.from(0).to(1)
    expect(result).not_to be_valid
  end

  it "is valid without any scores given" do
    match = FactoryBot.create(:match)

    expect(GameResult.new(match: match)).to be_valid
  end
end

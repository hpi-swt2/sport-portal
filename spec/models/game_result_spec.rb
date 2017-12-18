require 'rails_helper'

RSpec.describe GameResult, type: :model do
  it "is valid when produced by a factory" do
    result = FactoryBot.build(:game_result)
    result.save

    expect(result).to be_valid
  end

  it "fails validation with non-number scores" do
    result = FactoryBot.build(:game_result, score_home: "2a")
    result.save

    expect(result).not_to be_valid
  end

  it "is valid without any scores given" do
    result = GameResult.new
    match = FactoryBot.create(:match)
    match.game_results << result

    result.save
    expect(result).to be_valid
  end
end

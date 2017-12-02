require 'rails_helper'

describe "Tournament model", type: :model do

  it "is valid when produced by a factory" do
    league = FactoryBot.build(:league)
    expect(league).to be_valid
  end

end

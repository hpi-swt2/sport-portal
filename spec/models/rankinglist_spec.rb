require 'rails_helper'

RSpec.describe Rankinglist, type: :model do
  it "is valid when produced by a factory" do
    rankinglist = FactoryBot.build(:rankinglist)
    expect(rankinglist).to be_valid
  end
end

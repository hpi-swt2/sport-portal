require 'rails_helper'

describe "Event model", type: :model do

    it "should not validate without name" do
        league = FactoryBot.build(:league, name: nil)
        league.name = nil

        expect(league.valid?).to eq(false)
    end

    it "should not validate without discipline" do
        league = FactoryBot.build(:league, discipline: nil)
        league.discipline = nil

        expect(league.valid?).to eq(false)
    end

    it "should not validate without game_mode" do
        league = FactoryBot.build(:league, game_mode: nil)
        league.game_mode = nil

        expect(league.valid?).to eq(false)
    end

end

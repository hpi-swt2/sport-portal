require 'rails_helper'

describe "Event model", type: :model do

    it "should not validate when everything is specified correctly" do
        valid = League.new(name: "Weitwurfmeisterschaften",
        description: "Throw! Throw! Record!",
        discipline: "Kokosnussweitwurf",
        player_type: Event.player_types[:single], max_teams: 8,
        game_mode: League.game_modes[:round_robin]).valid?
        expect(valid).to eq(true)
    end

    it "should not validate without name" do
        invalid = League.new(description: "Throw! Throw! Record!",
        discipline: "Kokosnussweitwurf",
        player_type: Event.player_types[:single], max_teams: 8,
        game_mode: League.game_modes[:round_robin]).valid?
        expect(invalid).to eq(false)
    end

    it "should not validate without discipline" do
        invalid = League.new(name: "Weitwurfmeisterschaften",
        description: "Throw! Throw! Record!",
        player_type: Event.player_types[:single], max_teams: 8,
        game_mode: League.game_modes[:round_robin]).valid?
        expect(invalid).to eq(false)

        valid = League.new(name: "Weitwurfmeisterschaften",
        description: "Throw! Throw! Record!",
        discipline: "Kokosnussweitwurf",
        player_type: Event.player_types[:single], max_teams: 8,
        game_mode: League.game_modes[:round_robin]).valid?
        expect(valid).to eq(true)
    end

    it "should not validate without game_mode" do
        invalid = League.new(name: "Weitwurfmeisterschaften",
        description: "Throw! Throw! Record!",
        discipline: "Kokosnussweitwurf",
        player_type: Event.player_types[:single], max_teams: 8).valid?
        expect(invalid).to eq(false)
    end

end

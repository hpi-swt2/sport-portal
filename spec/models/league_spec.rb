require 'rails_helper'

describe "League model", type: :model do

    it "should get created with correct data" do
        league = League.new(name: "Weitwurfmeisterschaften",
            description: "Throw! Throw! Record!",
            discipline: "Kokosnussweitwurf",
            player_type: Event.player_types[:single], max_teams: 8,
            game_mode: League.game_modes[:round_robin])

        expect(league.name).to eq("Weitwurfmeisterschaften")
        expect(league.description).to eq("Throw! Throw! Record!")
        expect(league.discipline).to eq("Kokosnussweitwurf")
        expect(league.player_type).to eq(Event.player_types[:single])
        expect(league.max_teams).to eq(8)
        expect(league.game_mode).to eq(League.game_modes[:round_robin])
    end

end

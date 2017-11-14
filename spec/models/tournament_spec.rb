require 'rails_helper'

describe "Tournament model", type: :model do

    it "should get created with correct data" do
        tournament = Tournament.new(name: "Weitwurfmeisterschaften",
            description: "Throw! Throw! Record!",
            discipline: "Kokosnussweitwurf",
            player_type: Event.player_types[:single], max_teams: 8,
            game_mode: Tournament.game_modes[:double_elimination])

        expect(tournament.name).to eq("Weitwurfmeisterschaften")
        expect(tournament.description).to eq("Throw! Throw! Record!")
        expect(tournament.discipline).to eq("Kokosnussweitwurf")
        expect(tournament.player_type).to eq(Event.player_types[:single])
        expect(tournament.max_teams).to eq(8)
        expect(tournament.game_mode).to eq(Tournament.game_modes[:double_elimination])
    end

end

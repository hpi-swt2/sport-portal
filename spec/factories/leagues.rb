FactoryBot.define do
  factory :league do
    name "Weitwurfmeisterschaften"
    description "Throw! Throw! Record!"
    discipline "Kokosnussweitwurf"
    player_type Event.player_types[:single]
    max_teams 8
    game_mode League.game_modes[:round_robin]
  end
end

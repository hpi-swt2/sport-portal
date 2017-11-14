FactoryBot.define do
  factory :event do
    name "Weitwurfmeisterschaften"
    description "Throw! Throw! Record!"
    discipline "Kokosnussweitwurf"
    player_type Event.player_types[:single]
    max_teams 8
  end
end

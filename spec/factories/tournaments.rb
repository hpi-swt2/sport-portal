FactoryBot.define do
  factory :tournament, parent: :event do
    game_mode Tournament.game_modes[Tournament.game_modes.keys.sample]

    factory :tournament_with_teams, class: "Tournament", parent: :event_with_teams do
    end
  end
end

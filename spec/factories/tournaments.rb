FactoryBot.define do
  factory :tournament, parent: :event, class: :tournament do
    game_mode Tournament.game_modes[Tournament.game_modes.keys.sample]

    factory :tournament_with_teams, class: "Tournament", parent: :event_with_teams do
    end
  end
end

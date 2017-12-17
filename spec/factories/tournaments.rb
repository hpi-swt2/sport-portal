FactoryBot.define do
  factory :tournament, parent: :event, traits: [:has_dates], class: Tournament do
    game_mode Tournament.game_modes[Tournament.game_modes.keys.sample]

    factory :tournament_with_teams, class: "Tournament", parent: :event_with_teams, traits: [:has_dates] do
    end
  end
end

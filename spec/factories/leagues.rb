FactoryBot.define do
  factory :league, parent: :event, traits: [:has_dates], class: :league do
    game_mode League.game_modes[League.game_modes.keys.sample]
    gameday_duration 7

    factory :league_with_teams, class: "League", parent: :event_with_teams, traits: [:has_dates] do
    end
  end
end

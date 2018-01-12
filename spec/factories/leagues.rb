FactoryBot.define do
  factory :league, parent: :event, traits: [:has_dates], class: League do
    game_mode :round_robin
    gameday_duration 7

    factory :league_with_teams, class: League, parent: :event_with_teams, traits: [:has_dates] do
      game_mode :round_robin
      gameday_duration 7
    end
  end
end

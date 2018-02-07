FactoryBot.define do
  factory :league, parent: :event, traits: [:has_dates], class: League do
    game_mode :round_robin
    gameday_duration 7
  end
end

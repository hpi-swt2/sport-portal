FactoryBot.define do
  factory :league, parent: :event, class: League do
    game_mode :round_robin
    gameday_duration 7
  end
end

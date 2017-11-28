FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "name#{n}" }
    sequence(:description) { |n| "description#{n}" }
    sequence(:discipline) { |n| "discipline#{n}" }
    player_type Event.player_types[Event.player_types.keys.sample]
    # game mode is only defined for leagues atm change this and refactor tests once they are streamlined
    game_mode League.game_modes[League.game_modes.keys.sample]
    max_teams { rand(1..30) }
    deadline Date.tomorrow
    startdate Date.today + 2
    enddate Date.today + 3
  end
end

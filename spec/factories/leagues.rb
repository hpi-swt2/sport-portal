FactoryBot.define do
  factory :league, parent: :event, class: League do
    game_mode League.game_modes[League.game_modes.keys.sample]
  end
end

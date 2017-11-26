FactoryBot.define do
    factory :league, parent: :event do
        game_mode League.game_modes[League.game_modes.keys.sample]
    end
end

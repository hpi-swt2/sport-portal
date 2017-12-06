FactoryBot.define do
  factory :tournament, parent: :event, class: :tournament do
    game_mode Tournament.game_modes[Tournament.game_modes.keys.sample]
  end
end

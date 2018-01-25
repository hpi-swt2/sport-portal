FactoryBot.define do
  factory :tournament, parent: :event, traits: [:has_dates], class: Tournament do
    game_mode :ko
  end
end

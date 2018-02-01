FactoryBot.define do
  factory :rankinglist, parent: :event, class: Rankinglist do
    game_mode Rankinglist.game_modes.keys.sample
    initial_value 1.3
    player_type Event.player_types[:single]
  end

  trait :with_teams do
    transient do
      teams_count 5
    end
    after(:create) do |event, evaluator|
      FactoryBot.create_list(:team, evaluator.teams_count, events: [event])
    end
  end
end

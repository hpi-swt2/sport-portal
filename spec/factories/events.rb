# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :text
#  discipline           :string
#  player_type          :integer          not null
#  max_teams            :integer
#  game_mode            :integer          not null
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  startdate            :date
#  enddate              :date
#  deadline             :date
#  gameday_duration     :integer
#  owner_id             :integer
#  initial_value        :float
#  selection_type       :integer          default("fcfs"), not null
#  min_players_per_team :integer
#  max_players_per_team :integer
#  matchtype            :integer
#  bestof_length        :integer          default(1)
#  game_winrule         :integer
#  points_for_win       :integer          default(3)
#  points_for_draw      :integer          default(1)
#  points_for_lose      :integer          default(0)
#  image_data           :text
#

FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "name#{n}" }
    sequence(:description) { |n| "description#{n}" }
    sequence(:discipline) { |n| "discipline#{n}" }
    selection_type Event.selection_types[Event.selection_types.keys.sample]
    player_type :team
    # game mode is only defined for leagues atm change this and refactor tests once they are streamlined
    game_mode League.game_modes[League.game_modes.keys.sample]
    max_teams { rand(1..30) }
    matchtype :bestof
    bestof_length 5
    game_winrule :most_sets
    points_for_win 3
    points_for_draw 1
    points_for_lose 0

    min_players_per_team 1
    max_players_per_team 1
    association :owner, factory: :user, strategy: :build

    trait :has_dates do
      deadline { Date.current + 1 }
      startdate { Date.current + 2 }
      enddate { Date.current + 3 }
    end

    trait :single_player do
      player_type Event.player_types[:single]
    end

    trait :team_player do
      player_type Event.player_types[:team]
    end

    trait :passed_deadline do
      deadline { Date.current - 1 }
    end

    trait :with_teams do
      min_players_per_team 11
      max_players_per_team 15
      transient do
        teams_count 5
      end
      after(:create) do |event, evaluator|
        FactoryBot.create_list(:team, evaluator.teams_count, events: [event])
      end
    end

    trait :with_gameday do
      transient do
        gameday_count 5
      end
      after(:create) do |event, evaluator|
        FactoryBot.create_list(:gameday, evaluator.gameday_count, event: event)
      end
    end

    trait :with_matches do
      transient do
        matches_count 10
      end
      after(:create) do |event, evaluator|
        FactoryBot.create_list(:match, evaluator.matches_count, event: event)
      end
    end

    trait :fcfs do
      selection_type Event.selection_types[:fcfs]
    end

    after(:build) do |event|
      event.image = File.open("#{Rails.root}/spec/fixtures/valid_avatar.png")
    end
  end
end

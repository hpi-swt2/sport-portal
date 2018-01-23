# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  discipline       :string
#  player_type      :integer          not null
#  max_teams        :integer
#  game_mode        :integer          not null
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  startdate        :date
#  enddate          :date
#  deadline         :date
#  gameday_duration :integer
#  owner_id         :integer
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

    trait :with_matches do
      transient do
        matches_count 10
      end
      after(:create) do |event, evaluator|
        FactoryBot.create_list(:match, evaluator.matches_count, event: event)
      end
    end

    trait :with_users do
      transient do
        user_count 5
      end
      after(:create) do |event, evaluator|
        users = FactoryBot.create_list(:user, evaluator.user_count)
        users.each do |user|
          event.add_participant user
        end
      end
    end

    trait :fcfs do
      selection_type Event.selection_types[:fcfs]
    end
  end
end

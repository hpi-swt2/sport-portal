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
    player_type :team
    # game mode is only defined for leagues atm change this and refactor tests once they are streamlined
    game_mode League.game_modes[League.game_modes.keys.sample]
    max_teams { rand(1..30) }

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

    factory :event_with_teams do
      transient do
        teams_count 5
      end
      after(:create) do |event, evaluator|
        FactoryBot.create_list(:team, evaluator.teams_count, events: [event])
      end
    end

    factory :team_event do
      player_type Event.player_types[:team]
    end
  end
end

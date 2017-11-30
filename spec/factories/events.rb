# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  gamemode    :string
#  sport       :string
#  teamsport   :boolean
#  playercount :integer
#  gamesystem  :text
#  deadline    :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  startdate   :date
#  enddate     :date
#

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

        factory :event_with_teams do
          transient do
            teams_count 5
          end
          after(:create) do |event,evaluator|
            FactoryBot.create_list(:team, evaluator.teams_count, events: [event])
          end
        end
    end
end

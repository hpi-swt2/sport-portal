# == Schema Information
#
# Table name: gamedays
#
#  id          :integer          not null, primary key
#  description :string
#  starttime   :datetime
#  endtime     :datetime
#  event_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :gameday do
    description "MyString"
    starttime "2018-01-21 00:43:47"
    endtime "2018-01-21 00:43:47"
    association :event, factory: :event

    trait :with_matches do
      transient do
        match_count 5
      end
      after(:create) do |gameday, evaluator|
        FactoryBot.create_list(:match, evaluator.match_count, gameday: gameday)
      end
    end
  end
end

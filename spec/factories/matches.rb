# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  date         :date
#  place        :string
#  score_home   :integer
#  score_away   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_home_id :integer
#  team_away_id :integer
#

FactoryBot.define do
  factory :match do
    date Date.today
    sequence(:place) { |n| "Place #{n}" }
    association :team_away, :factory => :team
    association :team_home, :factory => :team
    score_home { rand(1..10) }
    score_away { rand(1..10) }
  end
end

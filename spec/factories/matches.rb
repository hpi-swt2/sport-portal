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
    date "2017-10-23"
    place "Place"
    association :team_away, :factory => :team
    association :team_home, :factory => :team
    score_home 12
    score_away 13
  end
end

# == Schema Information
#
# Table name: game_results
#
#  id         :integer          not null, primary key
#  score_home :integer
#  score_away :integer
#  match_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :game_result do
    score_home 1
    score_away 1
    association :match, factory: :match
  end
end

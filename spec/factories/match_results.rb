# == Schema Information
#
# Table name: match_results
#
#  id              :integer          not null, primary key
#  match_id        :integer
#  winner_advances :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryBot.define do
  factory :match_result do
    association :match, factory: :match
    winner_advances true
  end
end

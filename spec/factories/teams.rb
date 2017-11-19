# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    kindofsport "Football"
    description "This team is awesome"
    private false
  end
end

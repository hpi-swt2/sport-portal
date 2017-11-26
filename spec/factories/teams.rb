# == Schema Information
#
# Table name: teams
#
#  id            :integer          not null, primary key
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  description   :text
#  kind_of_sport :string
#  private       :boolean
#

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    kind_of_sport "Football"
    description "This team is awesome"
    private false
  end
end

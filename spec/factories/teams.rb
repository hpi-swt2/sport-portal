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
  end

  trait :with_owners do
    after(:create) do |team|
      team.owners = build_list :user, 2
    end
  end

  trait :with_members do
    after(:create) do |team|
      team.members = build_list :user, 5
    end
  end
end

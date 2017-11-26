# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  kind_of_sport :string
#  private     :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    kind_of_sport "Football"
    description "This team is awesome"
    private false
  end

  trait :with_owners do
    after(:create) do |team|
      team.owners = build_list :user, 2
      team.members << team.owners
    end
  end

  trait :with_members do
    after(:create) do |team|
      team.members = build_list :user, 5
    end
  end
end

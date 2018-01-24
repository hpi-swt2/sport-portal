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
#  single        :boolean          default(FALSE)
#

FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    kind_of_sport "Football"
    description "This team is awesome"
    private false

    after(:create) do |team|
      team.owners << create_list(:user, 1)
    end
  end

  trait :with_two_owners do
    after(:create) do |team|
      team.owners << create_list(:user, 1)
    end
  end

  trait :with_five_members do
    after(:create) do |team|
      team.members << create_list(:user, 4)
    end
  end

  trait :private do
    private true
  end
end

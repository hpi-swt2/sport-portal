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

class Team < ApplicationRecord
  validates :name, presence: true

  has_many :team_owners
  has_many :owners, through: :team_owners, source: :user

  has_many :team_members
  has_many :members, through: :team_members, source: :user


  validates :private, inclusion:  [true, false]
end

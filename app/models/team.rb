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
  validates :private, inclusion:  [true, false]

  has_and_belongs_to_many :events

  #has_many :team_owners
  #has_many :owners, through: :team_owners, source: :user

  #has_many :team_members
  #has_many :members, through: :team_members, source: :user

  has_many :team_users, class_name: "TeamUser"
  has_many :members, through: :team_users, source: :user
  has_many :owners, -> { where is_owner: true }, through: :team_users, source: :user


  # validates :owners, presence: true
  # validates :members, presence: true

  def owners_include?(user)
    owners.include? user
  end

  def has_multiple_owners?
    owners.length > 1
  end
end
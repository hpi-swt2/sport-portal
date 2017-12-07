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

class Team < ApplicationRecord
  validates :name, presence: true

  validates :private, inclusion:  [true, false]

  has_and_belongs_to_many :events

  has_many :team_members, source: :team_user, class_name: "TeamUser"
  has_many :team_owners, -> { where is_owner: true }, source: :team_user, class_name: "TeamUser"

  has_many :members, through: :team_members, source: :user
  has_many :owners, through: :team_owners, source: :user

  # validates :owners, presence: true
  # validates :members, presence: true

  def has_multiple_owners?
    owners.length > 1
  end
end

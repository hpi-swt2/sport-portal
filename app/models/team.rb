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

  scope :multiplayer, -> { where single: false }

  has_and_belongs_to_many :events

  has_many :team_members, source: :team_user, class_name: "TeamUser"
  has_many :team_owners, -> { where is_owner: true }, source: :team_user, class_name: "TeamUser"

  has_many :members, through: :team_members, source: :user
  has_many :owners, through: :team_owners, source: :user
  has_many :home_matches, as: :team_home, class_name: 'Match'
  has_many :away_matches, as: :team_away, class_name: 'Match'

  def matches
    home_matches.or away_matches
  end

  # validates :owners, presence: true
  # validates :members, presence: true

  def has_multiple_owners?
    owners.length > 1
  end

  def in_event?
    events.exists?
  end

  # these methods allow teams to be treated like matches. see Match model
  def winner
    self
  end

  def last_match_of(_team)
  end
end

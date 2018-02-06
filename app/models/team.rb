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
#  avatar_data   :text
#  single        :boolean          default(FALSE)
#

class Team < ApplicationRecord
  default_scope { order(created_at: :asc) }
  validates :name, presence: true

  validates :private, inclusion:  [true, false]

  scope :created_by_user, -> { where created_by_event: false }
  scope :created_by_event, -> { where created_by_event: true }

  has_many :participants
  has_many :events, through: :participants


  has_many :team_members, source: :team_user, class_name: "TeamUser"
  has_many :team_owners, -> { where is_owner: true }, source: :team_user, class_name: "TeamUser"

  has_many :members, through: :team_members, source: :user
  has_many :owners, through: :team_owners, source: :user
  has_many :home_matches, as: :team_home, class_name: 'Match'
  has_many :away_matches, as: :team_away, class_name: 'Match'

  include ImageUploader::Attachment.new(:avatar)

  def matches
    home_matches.or away_matches
  end

  def has_multiple_owners?
    owners.length > 1
  end

  def associated_with_event?
    events.exists?
  end

  def has_member?(user)
    members.include?(user)
  end

  def is_qualified_to_receive_notifications?
    not self.created_by_event?
  end

  # these methods allow teams to be treated like match results. see MatchResult model
  def advancing_participant
    self
  end

  def last_match_of(_team)
  end
end

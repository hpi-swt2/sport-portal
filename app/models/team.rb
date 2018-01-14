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

  has_many :team_members, source: :team_user, class_name: "TeamUser"
  has_many :team_owners, -> { where is_owner: true }, source: :team_user, class_name: "TeamUser"

  has_many :members, through: :team_members, source: :user
  has_many :owners, through: :team_owners, source: :user

  has_one :participant, as: :particable, class_name: 'Participants'

  # validates :owners, presence: true
  # validates :members, presence: true

  def initialize(*args)
    @participant ||= Participant.new
    super
  end

  def has_multiple_owners?
    owners.length > 1
  end

  # >>>>>> participating behaviour is encapsulated in Participant class

  def events
    @participant.events
  end

  def home_matches
    @participant.home_matches
  end

  def away_matches
    @participant.away_matches
  end

  def in_event?
    @participant.in_event?
  end

  def winner
    @participant.winner
  end

  def matches
    @participant.matches
  end

  def last_match_of(_team)
  end

  # end of participating behaviour <<<<<<
end

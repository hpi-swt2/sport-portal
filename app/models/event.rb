# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  discipline       :string
#  player_type      :integer          not null
#  max_teams        :integer
#  game_mode        :integer          not null
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  startdate        :date
#  enddate          :date
#  deadline         :date
#  gameday_duration :integer
#  owner_id         :integer
#  initial_value    :float
#

class Event < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :matches, -> { order 'gameday ASC' }, dependent: :delete_all
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :participants, class_name: 'User'
  has_many :organizers
  has_many :editors, through: :organizers, source: 'user'

  scope :active, -> { where('deadline >= ? OR type = ?', Date.current, "Rankinglist") }

  validates :name, :discipline, :game_mode, :player_type,  presence: true

  validates :max_teams, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  enum player_types: [:single, :team]

  def duration
    return if enddate.blank? || startdate.blank?
    enddate - startdate + 1
  end

  def end_after_start
    return if enddate.blank? || startdate.blank?
    errors.add(:enddate, I18n.t('activerecord.validations.must_be_after', other: Event.human_attribute_name(:startdate))) if enddate < startdate
  end

  def start_after_deadline
    return if startdate.blank? || deadline.blank?
    errors.add(:startdate, I18n.t('activerecord.validations.must_be_after', other: Event.human_attribute_name(:deadline))) if startdate < deadline
  end

  def deadline_has_passed?
    deadline < Date.current
  end

  def single_player?
    player_type == Event.player_types[:single]
  end

  # Everything below this is leagues only code and will be moved to Leagues.rb once there is an actual option to create Leagues AND Tourneys, etc.
  # Joining a single Player for a single Player Event
  # This method is only temporary until we have a working teams-infrastructure
  def add_single_player_team(user)
    if teams.length < max_teams
      teams << Team.new(name: "#{user.email}"  , private: false)
    end
  end

  # This method is only temporary until we have a working teams-infrastructure
  def remove_single_player_team(user)
    teams.where(name: "#{user.email}").destroy_all
  end

  def invalidate_schedule
    matches.delete_all
  end

  def add_participant(user)
    add_single_player_team(user)
    participants << user

    invalidate_schedule
  end

  def remove_participant(user)
    remove_single_player_team(user)
    participants.delete(user)

    invalidate_schedule
  end

  def has_participant?(user)
    participants.include?(user)
  end

  def can_join?(user)
    raise NotImplementedError
  end

  def can_leave?(user)
    single_player? && has_participant?(user)
  end

  def standing_of(team)
    'Gewinner ' + team.id.to_s
  end
end

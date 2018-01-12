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
  has_many :matches, -> { order '"gameday" ASC, "index" ASC' }, dependent: :delete_all
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :participants, class_name: 'User'
  has_many :organizers
  has_many :editors, through: :organizers, source: 'user'

  scope :active, -> { where('deadline >= ? OR type = ?', Date.current, "Rankinglist") }

  validates :name, :discipline, :game_mode, :player_type,  presence: true

  validates :max_teams, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  enum player_type: [:single, :team]

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

  def matches_per_gameday
    gamedays = []

    matches.each do |match|
      if gamedays.has_key? match.gameday
        gamedays[match.gameday] << match
      else
        gamedays[match.gameday] = []
      end
    end

    gamedays
  end

  def gamedays
    gamedays = []

    matches.each do |match|
      gamedays << match.gameday
    end

    gamedays.uniq
  end

  def deadline_has_passed?
    deadline < Date.current
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

  def generate_schedule
    raise NotImplementedError
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

  def participant_model
    single? ? User : Team
  end

  def can_join?(user)
    raise NotImplementedError
  end

  def can_leave?(user)
    single? && has_participant?(user)
  end

  def standing_of(team)
    I18n.t 'events.overview.unkown_standing', team: team.id.to_s
  end

  # this is a method that simplifies manual testing, not intended for production use
  # method not used at the moment since it is now testet with joined users
  #def add_test_teams
  #max_teams.times do |index|
  #teams << Team.new(name: "Team #{index}", private: false)
  #end
  #end

  def human_player_type
    self.class.human_player_type player_type
  end

  def human_game_mode
    self.class.human_game_mode game_mode
  end

  class << self
    def human_player_type(type)
      I18n.t("activerecord.attributes.event.player_types.#{type}")
    end

    # This method should be implemented by subclasses to provide correct game mode names
    def human_game_mode(mode)
      I18n.t("activerecord.attributes.#{name.downcase}.game_modes.#{mode}")
    end
  end
end

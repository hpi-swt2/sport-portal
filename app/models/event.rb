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

  def generate_schedule
    calculate_round_robin
  end

  def calculate_round_robin
    pairings_per_day = round_robin_pairings teams.to_a
    pairings_per_day.each_with_index do |day, gameday|
      day.each do |pairing|
        # Creating a match for every pairing if one of the teams is nil (which happens if there is an odd number of teams)
        # the other team will have to wait for this day
        matches << Match.new(team_home: pairing[0], team_away: pairing[1], gameday: gameday + 1) unless pairing[0].nil? or pairing[1].nil?
      end
    end
    save
  end

  # creates a twodimensional array of round robin pairings (one array per gameday) the inner array consists of the pairings
  def round_robin_pairings(teams_array)
    teams_array.push nil if teams_array.size.odd?
    n = teams_array.size
    pivot = teams_array.pop
    games = (n - 1).times.map do
      teams_array.rotate!
      [[teams_array.first, pivot]] + (1...(n / 2)).map { |j| [teams_array[j], teams_array[n - 1 - j]] }
    end
    games
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

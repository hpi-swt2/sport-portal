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
#  matchtype        :integer
#  bestof_length    :integer
#  game_winrule     :integer
#  points_for_win   :integer
#  points_for_draw  :integer
#  points_for_lose  :integer
#

class Event < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :matches, -> { order 'gameday ASC' }, dependent: :delete_all
  has_and_belongs_to_many :teams
  has_and_belongs_to_many :participants, class_name: 'User'
  has_many :organizers
  has_many :editors, through: :organizers, source: 'user'

  scope :active, -> { where('deadline >= ?', Date.current) }

  validates :name, :discipline, :game_mode, :player_type, :matchtype, :game_winrule, presence: true
  validates :deadline, :startdate, :enddate, presence: true
  validates :max_teams, numericality: { greater_than_or_equal_to: 0 } # this validation will be moved to League.rb once leagues are being created and not general event objects
  validates :points_for_win, :points_for_draw, :points_for_lose, numericality: { only_integer: true }
  validates :bestof_length, numericality: {only_integer: true, greater_than_or_equal_to: 0 }
  validate :end_after_start

  enum player_types: [:single, :team]
  enum matchtype: [:bestof]
  enum game_winrule: [:most_sets]

  def self.types
    %w(Tournament League)
  end

  def duration
    return if enddate.blank? || startdate.blank?
    enddate - startdate + 1
  end

  def end_after_start
    return if enddate.blank? || startdate.blank?
    if enddate < startdate
      errors.add(:enddate, "must be after startdate.")
    end
  end

  def deadline_has_passed?
    deadline < Date.current
  end

  def single_player?
    player_type == Event.player_types[:single]
  end

  # Everything below this is leagues only code and will be moved to Leagues.rb once there is an actual option to create Leagues AND Tourneys, etc.

  def add_test_teams
    max_teams.times do |index|
      teams << FactoryBot.create(:team)
    end
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
    participants << user
  end

  def remove_participant(user)
    participants.delete(user)
  end

  def has_participant?(user)
    participants.include?(user)
  end

  def can_join?(user)
    single_player? && (not has_participant?(user)) && (not deadline_has_passed?)
  end

  def can_leave?(user)
    single_player? && has_participant?(user)
  end

  def standing_of(team)
    'Gewinner ' + team.id.to_s
  end
end

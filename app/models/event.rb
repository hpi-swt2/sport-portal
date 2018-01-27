# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :text
#  discipline           :string
#  player_type          :integer          not null
#  max_teams            :integer
#  game_mode            :integer          not null
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  startdate            :date
#  enddate              :date
#  deadline             :date
#  gameday_duration     :integer
#  owner_id             :integer
#  initial_value        :float
#  selection_type       :integer          default("fcfs"), not null
#  min_players_per_team :integer
#  max_players_per_team :integer
#  matchtype            :integer
#  bestof_length        :integer          default(1)
#  game_winrule         :integer
#  points_for_win       :integer          default(3)
#  points_for_draw      :integer          default(1)
#  points_for_lose      :integer          default(0)
#  image_data           :text
#

class Event < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :matches, -> { order gameday: :asc, index: :asc }, dependent: :destroy
  has_and_belongs_to_many :teams
  has_many :organizers
  has_many :editors, through: :organizers, source: 'user'

  include ImageUploader::Attachment.new(:image)

  scope :active, -> { where('deadline >= ? OR type = ?', Date.current, "Rankinglist") }

  validates :name, :discipline, :game_mode, :player_type, :matchtype, :game_winrule, presence: true
  validates :max_teams, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000, allow_nil: true }
  validates :max_players_per_team, numericality: { greater_than_or_equal_to: :min_players_per_team }
  validates :points_for_win,
            :points_for_draw,
            :points_for_lose,
            :bestof_length,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  enum matchtype: [:bestof]
  enum game_winrule: [:most_sets]
  # fcfs_queue and selection should be added in the future
  enum selection_type: [:fcfs]

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

  def deadline_has_passed?
    deadline < Date.current
  end

  def add_team(team)
    teams << team
    invalidate_schedule
  end

  def remove_team(team)
    teams.delete(team)
    if single?
      team.destroy
    end
    invalidate_schedule
  end

  def generate_schedule
    raise NotImplementedError
  end

  def invalidate_schedule
    matches.delete_all
  end

  def add_participant(user)
    team = user.create_single_team
    add_team(team)
  end

  def has_participant?(user)
    teams.any? { |team| team.members.include?(user) }
  end

  def owns_participating_teams?(user)
    (user.owned_teams & teams).present?
  end

  def team_slot_available?
    return true unless max_teams.present?
    teams.count < max_teams
  end

  def participant_model
    single? ? User : Team
  end

  def can_join?(user)
    (not has_participant?(user)) && team_slot_available?
  end

  def can_join_fcfs?
    team_slot_available? && selection_type == 'fcfs'
  end

  def can_leave?(user)
    has_participant?(user)
  end

  def standing_of(team)
    I18n.t 'events.overview.unkown_standing'
  end

  # this is a method that simplifies manual testing, not intended for production use
  # method not used at the moment since it is now testet with joined users
  #def add_test_teams
  #max_teams.times do |index|
  #teams << Team.new(name: "Team #{index}", private: false)
  #end
  #end

  def human_selection_type
    self.class.human_selection_type selection_type
  end

  def human_player_type
    self.class.human_player_type player_type
  end

  def human_game_mode
    self.class.human_game_mode game_mode
  end

  def fitting_teams(user)
    all_teams = user.owned_teams.multiplayer
    fitting_teams = []
    all_teams.each do |team|
      if is_fitting?(team)
        fitting_teams << team
      end
    end
    fitting_teams
  end

  def is_fitting?(team)
    team_member_count = team.members.count
    min_players_per_team <= team_member_count && max_players_per_team >= team_member_count
  end

  class << self
    def human_selection_type(type)
      I18n.t("activerecord.attributes.event.selection_types.#{type}")
    end

    def human_player_type(type)
      I18n.t("activerecord.attributes.event.player_types.#{type}")
    end

    # This method should be implemented by subclasses to provide correct game mode names
    def human_game_mode(mode)
      I18n.t("activerecord.attributes.#{name.downcase}.game_modes.#{mode}")
    end
  end
end

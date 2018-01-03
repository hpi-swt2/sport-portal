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

  def create_single_team(user)
    team = Team.create(Hash[name: user.name, private: true, single: true])
    team.owners << user
    return team
  end

  def add_team(team)
    teams << team
  end

  def remove_team(team)
    teams.delete(team)
    if single?
      team.destroy
    end
  end

  def add_participant(user)
    team = create_single_team(user)
    add_team(team)
  end

  def has_participant?(user)
    team_members = []
    teams.each do |team|
      team_members += team.members
    end
    team_members.include?(user)
  end

  def ownes_participating_teams?(user)
    (user.owned_teams & teams).present?
  end

  def available_team_slot?
    teams.count < max_teams
  end

  def can_join?(user)
    (not has_participant?(user)) && available_team_slot?
  end

  def can_leave?(user)
    has_participant?(user)
  end

  def standing_of(team)
    'Gewinner ' + team.id.to_s
  end

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

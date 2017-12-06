# == Schema Information
#
# Table name: events
#
#  name                         :string
#  description                  :text
#  discipline                   :string
#  player_type                  :integer
#  max_teams                    :integer
#  game_mode                    :integer         not null
#  type                         :string
#  created_at                   :datetime        not null
#  deadline                     :date
#  startdate                    :date
#  enddate                      :date
#
#  updated_at                   :datetime        not null
#  index_events_on_game_mode    :index ["game_mode"]
#  index_events_on_player_type  :index ["player_type"]
#

class Event < ApplicationRecord
  belongs_to :owner, class_name: 'User'
  has_many :matches, -> { order 'gameday ASC' }, dependent: :delete_all
  has_and_belongs_to_many :teams
  validates :name, :discipline, :game_mode, presence: true
  validates :name, :discipline, :game_mode, :player_type, presence: true
  validates :deadline, :startdate, :enddate, presence: true
  validates :max_teams, numericality: { greater_than_or_equal_to: 0 } # this validation will be moved to League.rb once leagues are being created and not general event objects
  validate :end_after_start
  enum player_types: [:single, :team]

  def self.types
    %w(Tournament League)
  end

  has_many :organizers
  has_many :editors, through: :organizers, source: 'user'

  scope :active, -> { where('deadline >= ?', Date.current) }

  has_and_belongs_to_many :users

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

  # Everything below this is leagues only code and will be moved to Leagues.rb once there is an actual option to create Leagues AND Tourneys, etc.
end

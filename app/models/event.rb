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
  validates :name, :discipline, :game_mode, :player_type, presence: true
  validates :deadline, :startdate, :enddate, presence: true
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
    errors.add(:enddate, 'must be after startdate.') if enddate < startdate
  end
end

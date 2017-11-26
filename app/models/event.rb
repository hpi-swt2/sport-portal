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
  validates :name, :discipline, :game_mode, :type, :deadline, :startdate, :enddate, presence: true
  validate :end_after_start
  enum player_types: [:single, :team]

  def self.types
    %w(Tournament League)
  end

  scope :active, -> { where('deadline >= ?', Date.current) }

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
end

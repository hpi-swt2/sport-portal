# == Schema Information
#
# Table name: events
#
#  id           :integer          not null, primary key
#  name         :string
#  description  :text
#  gamemode     :string
#  sport        :string
#  teamsport    :boolean
#  playercount  :integer
#  gamesystem   :text
#  deadline     :date
#  startdate    :date
#  enddate      :date
#

class Event < ApplicationRecord
  validates :deadline, :startdate, :enddate, presence: true
  validate :end_after_start

  scope :active, -> { where('deadline >= ?', Date.current) }

  def duration
    return if enddate.blank? || startdate.blank?
    enddate - startdate + 1
  end

  private

  def end_after_start
    return if enddate.blank? || startdate.blank?
    if enddate < startdate
      errors.add(:enddate, "must be after startdate.")
    end
  end
end

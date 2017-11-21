class Event < ApplicationRecord
  validates :deadline, :startdate, :enddate, presence: true
  validate :end_after_start

  def duration
    return if enddate.blank? || startdate.blank?
    enddate - startdate + 1
  end

  private
    def end_after_start
      return if enddate.blank? || startdate.blank?
      if enddate < startdate
        errors.add(:enddate, " must be after startdate.")
      end
    end
  scope :active, -> { where('deadline >= ?', Date.current) }
end

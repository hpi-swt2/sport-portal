class Event < ApplicationRecord
	
	validates :deadline, :startdate, :enddate, :duration, presence: true
	validates :duration, numericality: {only_integer: true}
	validate :end_after_start
	validate :duration_fits_date

	private
	def end_after_start
		return if enddate.blank? || startdate.blank?
		if enddate < startdate 
			errors.add(:enddate, " must be after startdate.")
		end
	end

	def duration_fits_date
		return if enddate.blank? || startdate.blank? || duration.blank?
		if (enddate - startdate + 1) != duration
			errors.add(:duration, "must equal time between start- and enddate.")
		end
	end
end

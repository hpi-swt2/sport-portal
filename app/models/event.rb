class Event < ApplicationRecord
  belongs_to :creator, class_name: 'User'
  scope :active, -> { where('deadline >= ?', Date.current) }
end

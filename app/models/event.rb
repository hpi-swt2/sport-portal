class Event < ApplicationRecord
  scope :active, -> { where('deadline >= ?', Date.current) }
end

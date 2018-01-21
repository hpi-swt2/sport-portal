class Gameday < ApplicationRecord
  belongs_to :event
  has_many :matches
end

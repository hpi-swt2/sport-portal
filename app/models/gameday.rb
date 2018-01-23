class Gameday < ApplicationRecord
  belongs_to :event, dependent: :delete
  has_many :matches
end

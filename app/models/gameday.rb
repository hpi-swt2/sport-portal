class Gameday < ApplicationRecord
  belongs_to :event
  has_many :matches, dependent: :delete_all
end

class Participant < ApplicationRecord
  belongs_to :team
  belongs_to :event
end

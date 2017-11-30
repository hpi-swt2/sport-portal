class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user

  def is_owner?
    is_owner
  end
end

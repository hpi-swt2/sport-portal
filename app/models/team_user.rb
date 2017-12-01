# Class for members of teams. They can be owners with advanced rights.
# By default, new TeamUsers are no owners.
class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  after_initialize :init
  
  def init
    self.is_owner ||= false # New team members are by default no team owners
  end
end

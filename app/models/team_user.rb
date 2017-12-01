class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  after_initialize :init

  def is_owner?
    is_owner
  end

  def init
    self.is_owner ||= false # New team members are by default no team owners
  end
end

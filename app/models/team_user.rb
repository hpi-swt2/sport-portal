# == Schema Information
#
# Table name: team_users
#
#  team_id  :integer          not null
#  user_id  :integer          not null
#  is_owner :boolean
#  id       :integer          not null, primary key
#

# Class for members of teams. They can be owners with advanced rights.
# By default, new TeamUsers are no owners.
class TeamUser < ApplicationRecord
  belongs_to :team
  belongs_to :user
  before_create :init

  def init
    self.is_owner ||= false # New team members are by default no team owners
  end

  def assign_ownership
    self.is_owner = true
    self.save
  end

  def delete_ownership
    self.is_owner = false
    self.save
  end
end

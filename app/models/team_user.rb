# == Schema Information
#
# Table name: team_users
#
#  team_id    :integer          not null
#  user_id    :integer          not null
#  is_owner   :boolean
#  id         :integer          not null, primary key
#  created_at :datetime
#

# Class for members of teams. They can be owners with advanced rights.
# By default, new TeamUsers are no owners.
class TeamUser < ApplicationRecord
  default_scope { order(created_at: :asc) }
  belongs_to :team
  belongs_to :user
  before_create :init
  after_create :send_mail_when_created

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

  private
    def send_mail_when_created
      team = Team.find(team_id)
      if team.is_qualified_to_receive_notifications?
        TeamMailer.user_added_to_team(User.find(user_id), team).deliver_now
      end
    end
end

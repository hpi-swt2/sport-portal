# == Schema Information
#
# Table name: teams
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  kind_of_sport :string
#  private     :boolean          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Team < ApplicationRecord
  validates :name, presence: true

  validates :private, inclusion:  [true, false]

  has_and_belongs_to_many :events

  #has_many :team_owners
  #has_many :owners, through: :team_owners, source: :user

  #has_many :team_members
  #has_many :members, through: :team_members, source: :user

  has_many :team_members, class_name: "TeamUser", source: :team_user, dependent: :destroy
  has_many :team_owners, -> { where is_owner: true }, class_name: "TeamUser", source: :team_user
  has_many :members, through: :team_members, source: :user
  has_many :owners, through: :team_owners, source: :user do
    def << (user_or_users)
      users = Array(user_or_users)
      team = proxy_association.owner
      users.each { |user|
        team_member = team.team_members.where(user_id: user.id, team_id: team.id).first_or_initialize
        team_member.is_owner = true
        team_member.save
      }
    end
    def include? (user)
      proxy_association.owner.team_members.exists?(
          user_id: user.id, team_id: proxy_association.owner.id, is_owner: true
      )
    end
    def - (users)
      team = proxy_association.owner
      users.each { |user|
        team_member = team.team_members.where(user_id: user.id, team_id: team.id, is_owner: true)
        if team_member.exists?
          team_member.is_owner = false
          team_member.save
        end
      }
    end
  end


  # validates :owners, presence: true
  # validates :members, presence: true

  def has_multiple_owners?
    owners.length > 1
  end
end
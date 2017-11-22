# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  description:text
#  kindofsport:string
#  private    :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ApplicationRecord
  validates :name, presence: true
  validates :private, inclusion: { :in => [true, false] }

  has_many :team_owners
  has_many :owners, through: :team_owners, source: :user

  has_many :team_members
  has_many :members, through: :team_members, source: :user

  # validates :owners, :length => { :minimum => 1}
  # validates :members, :length => { :minimum => 1}

end

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
end

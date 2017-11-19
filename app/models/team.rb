# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Team < ApplicationRecord
  validates :name, presence: true

  has_and_belongs_to_many(:owners, class_name: 'User', join_table: 'team_owners')
  has_and_belongs_to_many(:members, class_name: 'User', join_table: 'team_members')

end

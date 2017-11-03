# == Schema Information
#
# Table name: players
#
#  id         :integer          not null, primary key
#  first_name :string
#  last_name  :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Player < ApplicationRecord
  validates :first_name, presence: true
end

# == Schema Information
#
# Table name: organizers
#
#  id         :integer          not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#  event_id   :integer
#

class Organizer < ApplicationRecord
  belongs_to :user
  belongs_to :event
end

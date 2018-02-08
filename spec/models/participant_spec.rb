# == Schema Information
#
# Table name: participants
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  team_id    :integer
#  rating     :float
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

describe 'Participant model', type: :model do

  it "belongs to an event" do
    relation = Participant.reflect_on_association(:event)
    expect(relation.macro).to eq :belongs_to
  end
  it "belongs to a team" do
    relation = Participant.reflect_on_association(:team)
    expect(relation.macro).to eq :belongs_to
  end
end

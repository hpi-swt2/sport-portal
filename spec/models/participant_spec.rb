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

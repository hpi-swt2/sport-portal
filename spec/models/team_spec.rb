# == Schema Information
#
# Table name: teams
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Team, type: :model do
  it "is valid when produced by a factory" do
    team = FactoryBot.build(:team)
    expect(team).to be_valid
  end
end

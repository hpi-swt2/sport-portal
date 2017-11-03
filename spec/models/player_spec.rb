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

require 'rails_helper'

RSpec.describe Player, type: :model do
  it "is valid when produced by a factory" do
    match = FactoryBot.build(:player)
    expect(match).to be_valid
  end
end

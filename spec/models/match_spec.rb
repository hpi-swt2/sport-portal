# == Schema Information
#
# Table name: matches
#
#  id           :integer          not null, primary key
#  date         :date
#  place        :string
#  score_home   :integer
#  score_away   :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  team_home_id :integer
#  team_away_id :integer
#

require 'rails_helper'

RSpec.describe Match, type: :model do
  it "is valid when produced by a factory" do
    match = FactoryBot.build(:match)
    expect(match).to be_valid
  end
end

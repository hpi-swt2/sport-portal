# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  discipline       :string
#  player_type      :integer          not null
#  max_teams        :integer
#  game_mode        :integer          not null
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  startdate        :date
#  enddate          :date
#  deadline         :date
#  gameday_duration :integer
#  owner_id         :integer
#  initial_value    :float
#  selection_type   :integer          default("fcfs"), not null
#

require 'rails_helper'

RSpec.describe Rankinglist, type: :model do
  it "is valid when produced by a factory" do
    rankinglist = FactoryBot.build(:rankinglist)
    expect(rankinglist).to be_valid
  end
end

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
#  matchtype        :integer
#  bestof_length    :integer          default(1)
#  game_winrule     :integer
#  points_for_win   :integer          default(3)
#  points_for_draw  :integer          default(1)
#  points_for_lose  :integer          default(0)
#

require 'rails_helper'

RSpec.describe Rankinglist, type: :model do
  it "is valid when produced by a factory" do
    rankinglist = FactoryBot.build(:rankinglist)
    expect(rankinglist).to be_valid
  end
end

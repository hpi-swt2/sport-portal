# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :text
#  discipline           :string
#  player_type          :integer          not null
#  max_teams            :integer
#  game_mode            :integer          not null
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  startdate            :date
#  enddate              :date
#  deadline             :date
#  gameday_duration     :integer
#  owner_id             :integer
#  initial_value        :float
#  selection_type       :integer          default("fcfs"), not null
#  min_players_per_team :integer
#  max_players_per_team :integer
#  matchtype            :integer
#  bestof_length        :integer          default(1)
#  game_winrule         :integer
#  points_for_win       :integer          default(3)
#  points_for_draw      :integer          default(1)
#  points_for_lose      :integer          default(0)
#  image_data           :text
#

require 'rails_helper'

RSpec.describe Rankinglist, type: :model do
  it "is valid when produced by a factory" do
    rankinglist = FactoryBot.build(:rankinglist)
    expect(rankinglist).to be_valid
  end

  it "sets the initial value for participants correctly" do
    rankinglist = FactoryBot.create(:rankinglist)
    user = FactoryBot.create(:user)
    rankinglist.add_participant(user)
    participant = rankinglist.participants.first
    expect(participant.rating).to eq(rankinglist.initial_value)
  end
end

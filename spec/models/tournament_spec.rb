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
#  image_data           :text
#
require 'rails_helper'
require 'models/actual_event_examples'

describe "Tournament model", type: :model do

  it "is valid when produced by a factory" do
    tournament = FactoryBot.build(:tournament)
    expect(tournament).to be_valid
  end

  it_should_behave_like 'an actual event', for_class: :tournament

end

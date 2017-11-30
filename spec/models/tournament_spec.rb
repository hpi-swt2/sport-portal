# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  name        :string
#  description :text
#  gamemode    :string
#  sport       :string
#  teamsport   :boolean
#  playercount :integer
#  gamesystem  :text
#  deadline    :date
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  startdate   :date
#  enddate     :date
#

require 'rails_helper'

describe "Tournament model", type: :model do

    it "is valid when produced by a factory" do
      league = FactoryBot.build(:league)
      expect(league).to be_valid
    end

end

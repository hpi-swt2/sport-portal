# == Schema Information
#
# Table name: gamedays
#
#  id          :integer          not null, primary key
#  description :string
#  starttime   :datetime
#  endtime     :datetime
#  event_id    :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

require 'rails_helper'

RSpec.describe Gameday, type: :model do

  let(:gameday) { FactoryBot.build(:gameday) }
  it 'is valid when produced by a factory' do
    expect(gameday).to be_valid
  end
  it 'should have an attribute starttime' do
    expect(Gameday.column_names.include? 'starttime').to eq true
  end
  it 'should have an attribute endtime' do
    expect(Gameday.column_names.include? 'endtime').to eq true
  end
  it 'should have an attribute description' do
    expect(Gameday.column_names.include? 'description').to eq true
  end
  it 'should have an association event' do
    relation = Gameday.reflect_on_association(:event)
    expect(relation.macro).to eq :belongs_to
  end
  it 'should have an association matches' do
    relation = Gameday.reflect_on_association(:matches)
    expect(relation.macro).to eq :has_many
  end

  it 'should not be valid if starttime is after endtime' do
    gameday.starttime = Date.current + 3.days
    gameday.endtime = Date.current
    gameday.save
    expect(gameday).not_to be_valid
  end
end

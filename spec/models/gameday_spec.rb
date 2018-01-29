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
end

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
#

require 'rails_helper'

describe 'Event model', type: :model do

  let(:event) { FactoryBot.build(:event) }

  it 'should not validate without name' do
    event = FactoryBot.build(:event, name: nil)
    expect(event.valid?).to eq(false)
  end

  it 'should not validate without discipline' do
    event = FactoryBot.build(:event, discipline: nil)
    expect(event.valid?).to eq(false)
  end

  it 'should not validate without game_mode' do
    event = FactoryBot.build(:event, game_mode: nil)
    expect(event.valid?).to eq(false)
  end

  it 'should only show active events' do
    new_event = FactoryBot.create(:event, deadline: Date.current)
    old_event = FactoryBot.create(:event, deadline: Date.yesterday)

    expect(Event.active).to include(new_event)
    expect(Event.active).not_to include(old_event)
    expect(Event.all).to include(new_event, old_event)
  end

  it 'should have an association teams' do
    relation = Event.reflect_on_association(:teams)
    expect(relation.macro).to eq :has_and_belongs_to_many
  end

  it 'should know if it is for single players' do
    single_player_event = FactoryBot.build :event, :single_player
    expect(single_player_event).to be_single
  end

  it 'should know if its deadline has passed' do
    passed_deadline_event = FactoryBot.build :event, :passed_deadline
    expect(passed_deadline_event.deadline_has_passed?).to be true
  end

  it 'generate_Schedule? should raise a NotImplementedError' do
    event = FactoryBot.build :event
    # This is apparently not the correct way to implement an abstract method in ruby.
    # (https://stackoverflow.com/a/2502835/8921181, http://ruby-doc.org/core-2.2.0/NotImplementedError.html)
    # But it is the only way I know of right now to somewhat document that this has to be implemented by subclasses.
    expect { event.generate_schedule }.to raise_error NotImplementedError
  end
end

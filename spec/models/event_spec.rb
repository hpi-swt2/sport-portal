require 'rails_helper'

describe "Event model", type: :model do

  let(:event) { FactoryBot.build(:league) }

  it "should not validate without name" do
    league = FactoryBot.build(:league, name: nil)
    expect(league.valid?).to eq(false)
  end

  it "should not validate without discipline" do
    league = FactoryBot.build(:league, discipline: nil)
    expect(league.valid?).to eq(false)
  end

  it "should not validate without game_mode" do
    league = FactoryBot.build(:league, game_mode: nil)
    expect(league.valid?).to eq(false)
  end

  it "should have an attribute deadline" do
    date = Date.tomorrow
    expect(event.deadline).to eq date

    event.deadline = nil
    expect(event).not_to be_valid
  end

  it "should have an attribute startdate" do
    date = Date.tomorrow + 1
    expect(event.startdate).to eq date

    expect(event).to be_valid
    event.startdate = nil
    expect(event).not_to be_valid
  end

  it "should have an attribute enddate" do
    date = Date.tomorrow + 2
    expect(event.enddate).to eq date

    expect(event).to be_valid
    event.enddate = nil
    expect(event).not_to be_valid
  end

  it "should not be possible to have an enddate, that is before the startdate" do
    expect(event).to be_valid
    event.enddate = Date.today
    expect(event).not_to be_valid
  end

  it "should be possible to get the duration in day of an event" do
    expect(event.duration).to eq(2)
  end

  it "should only show active events" do
    new_event = FactoryBot.create(:event, deadline: Date.current)
    old_event = FactoryBot.create(:event, deadline: Date.yesterday)

    expect(Event.active).to include(new_event)
    expect(Event.active).not_to include(old_event)
    expect(Event.all).to include(new_event, old_event)
  end

  it "should have an association participants" do
    relation = Event.reflect_on_association(:users)
    expect(relation.macro).to eq :has_and_belongs_to_many
  end
end

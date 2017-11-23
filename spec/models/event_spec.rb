require 'rails_helper'

RSpec.describe Event, type: :model do

  before(:each) do
    @event = FactoryBot.create :event
    @user = FactoryBot.create(:user, password: '123456', password_confirmation: '123456')
  end

  it "should have an attribute deadline" do
    @date = Date.new(2017,11,16)
    expect(@event.deadline).to eq(@date)

    @event.deadline = nil
    expect(@event).not_to be_valid
  end
  it "should have an attribute startdate" do
    @date = Date.new(2017,12,01)
    expect(@event.startdate).to eq(@date)

    expect(@event).to be_valid
    @event.startdate = nil
    expect(@event).not_to be_valid
  end

  it "should have an attribute enddate" do
    @date = Date.new(2017,12,05)
    expect(@event.enddate).to eq(@date)

    expect(@event).to be_valid
    @event.enddate = nil
    expect(@event).not_to be_valid
  end

  it "should not be possible to have an enddate, that is before the startdate" do
    expect(@event).to be_valid
    @event.enddate = Date.new(2017,11,30)
    expect(@event).not_to be_valid
  end

  it "should be possible to get the duration in day of an event" do
    expect(@event.duration).to eq(5)
  end

  it "should only show active events" do
    @new_event = FactoryBot.create(:event, deadline: Date.current)
    @old_event = FactoryBot.create(:event)

    expect(Event.active).to include(@new_event)
    expect(Event.active).to_not include(@old_event)
    expect(Event.all).to include(@new_event, @old_event)
  end

  it "should be able to access all participants" do
    skip("Test for event.users")
    # expect(@event.users).to include(@user)
  end
end

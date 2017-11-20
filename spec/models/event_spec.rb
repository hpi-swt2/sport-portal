require 'rails_helper'

RSpec.describe Event, type: :model do

it "should have an attribute deadline" do
    @event = FactoryBot.create :event
    @date = Date.new(2017,11,16)
    expect(@event.deadline).to eq(@date)
  end
  it "should have an attribute startdate" do
    @event = FactoryBot.create :event
    @date = Date.new(2017,12,01)
    expect(@event.startdate).to eq(@date)
  end

  it "should have an attribute enddate" do
    @event = FactoryBot.create :event
    @date = Date.new(2017,12,05)
    expect(@event.enddate).to eq(@date)
  end

  it "should have an attribute duration" do
    @event = FactoryBot.create :event
    @duration = 5
    expect(@event.duration).to eq(@duration)
  end

  it "should have a deadline, startdate, enddate and duration" do
    @event = Event.create(name: "NAME", description: "DESCRIPTION", gamemode: "GAMEMODE",
    sport: "SPORT", teamsport: false, playercount: 1, gamesystem: "GAMESYSTEM",
    deadline: nil, startdate: nil, enddate: nil, duration: nil)

    expect(@event).not_to be_valid
  end

  it "should not be possible to have an enddate, that is before the startdate" do
    @event = Event.create(name: "NAME", description: "DESCRIPTION", gamemode: "GAMEMODE",
    sport: "SPORT", teamsport: false, playercount: 1, gamesystem: "GAMESYSTEM",
    deadline: Date.new(2017,11,16), startdate: Date.new(2017,12,05), enddate: Date.new(2017,12,01), duration: 10)
  
    expect(@event).not_to be_valid
  end  

  it "should be persistent that duration is the difference between start- and enddate" do
    @event = Event.create(name: "NAME", description: "DESCRIPTION", gamemode: "GAMEMODE",
    sport: "SPORT", teamsport: false, playercount: 1, gamesystem: "GAMESYSTEM",
    deadline: Date.new(2017,11,16), startdate: Date.new(2017,12,01), enddate: Date.new(2017,12,05), duration: 6)

    expect(@event).not_to be_valid
  end

end

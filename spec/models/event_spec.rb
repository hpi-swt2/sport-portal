require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:context) do
  	@event = FactoryBot.create :event
  end
  
  it "should have an attribute deadline" do
  	@date = Date.new(2017,11,16)
  	expect(@event.deadline).to eq(@date)
  end

  it "should have an attribute startdate" do
    @date = Date.new(2017,12,01)
    expect(@event.startdate).to eq(@date)
  end

  it "should have an attribute enddate" do
    @date = Date.new(2017,12,05)
    expect(@event.enddate).to eq(@date)
  end

  it "should have an attribute duration" do
    @duration = 5
    expect(@event.duration).to eq(@duration)
  end

  after(:context) do
  	@event.destroy
  end
end

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

  after(:context) do
  	@event.destroy
  end
end

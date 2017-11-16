require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:context) do
  	@event = FactoryBot.create :event
  end
  it "should have a attribute deadline" do
  	@date = Date.new(2017,11,16)
  	expect(@event.deadline).to eq(@date)
  end
  after(:context) do
  	@event.destroy
  end
end

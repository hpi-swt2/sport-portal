require 'rails_helper'

RSpec.describe Event, type: :model do
  before(:context) do
  	@event = FactoryBot.create :event
  end

  it "should have a attribute deadline" do
    @date = Date.new(2017,11,16)
    expect(@event.deadline).to eq(@date)
  end

  it "should only show active events" do
    @new_event = FactoryBot.create(:event, deadline: Date.current)
    @old_event = FactoryBot.create(:event)

    expect(Event.active).to include(@new_event)
    expect(Event.active).to_not include(@old_event)
    expect(Event.all).to include(@new_event, @old_event)
  end

  after(:context) do
  	@event.destroy
  end
end

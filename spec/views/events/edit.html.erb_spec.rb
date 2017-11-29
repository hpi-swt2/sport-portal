require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    assign(:event, FactoryBot.build(:event))
    @user = FactoryBot.create :user
    sign_in @user
    @event = assign(:event, FactoryBot.create(:event))
    @event.editors << @user
  end

  it "renders the edit event form" do
      render
      expect(rendered).to have_css("form[action='#{event_path(@event)}'][method='post']", count: 1)

  end
end
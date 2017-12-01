require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    assign(:event, FactoryBot.build(:event))
    @user = FactoryBot.create :user
    sign_in @user
    @event = assign(:event, Event.create!(
      :name => "MyString",
      :description => "MyText",
      :owner => FactoryBot.build(:user),
      :game_mode => "MyString",
      :max_teams => 20,
      :player_type => Event.player_types[Event.player_types.keys.sample],
      :discipline => "MyString",
      :deadline => Date.new(2017,11,16),
      :startdate => Date.new(2017,12,01),
      :enddate => Date.new(2017,12,05)
    ))
    @event.editors << @user
  end

  it "renders the edit event form" do
      render
      expect(rendered).to have_css("form[action='#{event_path(@event)}'][method='post']", count: 1)

  end
end
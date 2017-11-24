require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :name => "MyString",
      :description => "MyText",
      :game_mode => "MyString",
      :player_type => Event.player_types[Event.player_types.keys.sample],
      :discipline => "MyString",
      :deadline => Date.new(2017,11,16),
      :startdate => Date.new(2017,12,01),
      :enddate => Date.new(2017,12,05)
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "input[name=?]", "event[game_mode]"

      assert_select "input[name=?]", "event[discipline]"

      assert_select "input[name=?]", "event[deadline]"

      assert_select "input[name=?]", "event[startdate]"

      assert_select "input[name=?]", "event[enddate]"

    end
  end
end

require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :name => "MyString",
      :description => "MyText",
      :gamemode => "MyString",
      :sport => "MyString",
      :teamsport => false,
      :playercount => 1,
      :gamesystem => "MyText",
      :deadline => Date.new(2017,11,16),
      :startdate => Date.new(2017,12,01),
      :enddate => Date.new(2017,12,05),
      :duration => 5
    ))
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "input[name=?]", "event[gamemode]"

      assert_select "input[name=?]", "event[sport]"

      assert_select "input[name=?]", "event[teamsport]"

      assert_select "input[name=?]", "event[playercount]"

      assert_select "textarea[name=?]", "event[gamesystem]"

      assert_select "input[name=?]", "event[deadline]"

      assert_select "input[name=?]", "event[startdate]"

      assert_select "input[name=?]", "event[enddate]"

      assert_select "input[name=?]", "event[duration]"
    end
  end
end

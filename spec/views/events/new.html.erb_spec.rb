require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, Event.new(
      :name => "MyString",
      :description => "MyText",
      :gamemode => "MyString",
      :sport => "MyString",
      :teamsport => false,
      :playercount => 1,
      :gamesystem => "MyText",
      :deadline => Date.new(2017,11,16),
      :startdate => Date.new(2017,12,01)
    ))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "input[name=?]", "event[gamemode]"

      assert_select "input[name=?]", "event[sport]"

      assert_select "input[name=?]", "event[teamsport]"

      assert_select "input[name=?]", "event[playercount]"

      assert_select "textarea[name=?]", "event[gamesystem]"

      assert_select "input[name=?]", "event[deadline]"

      assert_select "input[name=?]", "event[startdate]"
    end
  end

end

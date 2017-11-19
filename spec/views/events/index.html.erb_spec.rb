require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    assign(:events, [
      Event.create!(
        :name => "Name",
        :description => "MyText",
        :gamemode => "Gamemode",
        :sport => "Sport",
        :teamsport => false,
        :playercount => 2,
        :gamesystem => "Gamesystem",
        :deadline => Date.new(2017,11,16),
        :startdate => Date.new(2017,12,01),
        :enddate => Date.new(2017,12,05),
        :duration => 5
      ),
      Event.create!(
        :name => "Name",
        :description => "MyText",
        :gamemode => "Gamemode",
        :sport => "Sport",
        :teamsport => false,
        :playercount => 2,
        :gamesystem => "Gamesystem2",
        :deadline => Date.new(2017,11,16),
        :startdate => Date.new(2017,12,01),
        :enddate => Date.new(2017,12,05),
        :duration => 5
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Gamemode".to_s, :count => 2
    assert_select "tr>td", :text => "Sport".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Gamesystem".to_s, :count => 1
    assert_select "tr>td", :text => "Gamesystem2".to_s, :count => 1
    assert_select "tr>td", :text => Date.new(2017,11,16).to_s, :count => 2
    assert_select "tr>td", :text => Date.new(2017,12,01).to_s, :count => 2
    assert_select "tr>td", :text => Date.new(2017,12,05).to_s, :count => 2
    assert_select "tr>td", :text => 5.to_s, :count => 2
  end
end

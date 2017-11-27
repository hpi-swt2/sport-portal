require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
    @events = assign(:events, [
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
        :enddate => Date.new(2017,12,05)
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
        :enddate => Date.new(2017,12,05)
      )
    ])
    @events.first.editors << @user
    @events.last.editors << @user
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gamemode".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Gamesystem".to_s, :count => 1
    assert_select "tr>td", :text => "Gamesystem2".to_s, :count => 1
    assert_select "tr>td", :text => Date.new(2017,11,16).to_s, :count => 2
    assert_select "tr>td", :text => Date.new(2017,12,01).to_s, :count => 2
    assert_select "tr>td", :text => Date.new(2017,12,05).to_s, :count => 2

   end

  it "renders styled buttons" do
    render
    expect(rendered).to have_css('a.btn.btn-default.btn-xs')
    expect(rendered).to have_css('a.btn.btn-danger.btn-xs')
    expect(rendered).to have_css('a.btn.btn-primary')
  end

  it "renders a striped table" do
    render
    expect(rendered).to have_css('table.table-striped')
  end

end

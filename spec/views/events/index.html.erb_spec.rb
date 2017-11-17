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
        :creator => FactoryBot.build(:user)
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
        :creator => FactoryBot.build(:user)
      )
    ])
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gamemode".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Gamesystem".to_s, :count => 1
    assert_select "tr>td", :text => "Gamesystem2".to_s, :count => 1
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

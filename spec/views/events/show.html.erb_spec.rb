require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, Event.create!(
      :name => "Name",
      :description => "MyText",
      :gamemode => "Gamemode",
      :sport => "Sport",
      :teamsport => false,
      :playercount => 2,
      :gamesystem => "MyText",
      :deadline => Date.new(2017,11,16),
      :startdate => Date.new(2017,12,01),
      :enddate => Date.new(2017,12,05)
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Gamemode/)
    expect(rendered).to match(/Sport/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/2017-11-16/)
    expect(rendered).to match(/2017-12-01/)
    expect(rendered).to match(/2017-12-05/)
  end
end

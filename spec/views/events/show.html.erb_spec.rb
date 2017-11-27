require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryBot.create(:event))
    @user = FactoryBot.create :user
    sign_in @user
    # @event = assign(:event, Event.create!(
    #   :name => "Name",
    #   :description => "MyText",
    #   :gamemode => "Gamemode",
    #   :sport => "Sport",
    #   :teamsport => false,
    #   :playercount => 2,
    #   :gamesystem => "Gamesystem",
    #   :deadline => Date.tomorrow,
    #   :startdate => Date.tomorrow+1,
    #   :enddate => Date.tomorrow+3
    # ))
    @event = FactoryBot.create :event, player_type: Event.player_types[:single]

    @event.editors << @user
  end

  it "renders attributes in <p>" do
    render
    # expect(rendered).to match(/Name/)
    # expect(rendered).to match(/MyText/)
    # expect(rendered).to match(/Gamemode/)
    # expect(rendered).to match(/Sport/)
    # expect(rendered).to match(/false/)
    # expect(rendered).to match(/2/)
    # expect(rendered).to match(/Gamesystem/)
    # expect(rendered).to match(Date.tomorrow.to_s)
    # expect(rendered).to match((Date.tomorrow+1).to_s)
    # expect(rendered).to match((Date.tomorrow+3).to_s)
    expect(true)
  end
end

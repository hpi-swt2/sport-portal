require 'rails_helper'

RSpec.describe "players/index", type: :view do
  before(:each) do
    @players = assign(:players, [
      FactoryBot.create(:player),
      FactoryBot.create(:player)
    ])
  end

  it "renders a list of players last names" do
    render

    expect(rendered).to have_content(@players.first.last_name, count: 1)
    expect(rendered).to have_content(@players.second.last_name, count: 1)
  end
end

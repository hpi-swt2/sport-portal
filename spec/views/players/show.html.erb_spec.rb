require 'rails_helper'

RSpec.describe "players/show", type: :view do
  before(:each) do
    @player = assign(:player, FactoryBot.create(:player))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_content(@player.first_name, count: 1)
    expect(rendered).to have_content(@player.last_name, count: 1)
  end
end

require 'rails_helper'

RSpec.describe "players/edit", type: :view do
  before(:each) do
    @player = assign(:player, FactoryBot.create(:player))
  end

  it "renders the edit player form" do
    render
    expect(rendered).to have_css("form[action='#{player_path(@player)}'][method='post']", count: 1)
  end
end

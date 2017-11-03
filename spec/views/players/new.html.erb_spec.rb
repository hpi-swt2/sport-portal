require 'rails_helper'

RSpec.describe "players/new", type: :view do
  before(:each) do
    assign(:player, FactoryBot.build(:player))
  end

  it "renders new player form" do
    render
    expect(rendered).to have_css("form[action='#{players_path}'][method='post']", count: 1)
  end
end

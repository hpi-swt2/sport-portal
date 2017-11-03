require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  before(:each) do
    @teams = assign(:teams, [
      FactoryBot.create(:team),
      FactoryBot.create(:team)
    ])
  end

  it "renders a list of teams" do
    render
    expect(rendered).to have_content(@teams.first.name, count: 1)
    expect(rendered).to have_content(@teams.second.name, count: 1)
  end
end

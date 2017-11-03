require 'rails_helper'

RSpec.describe "teams/edit", type: :view do
  before(:each) do
    @team = assign(:team, FactoryBot.create(:team))
  end

  it "renders the edit team form" do
    render
    expect(rendered).to have_css("form[action='#{team_path(@team)}'][method='post']", count: 1)
  end
end

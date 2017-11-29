require 'rails_helper'

RSpec.describe "matches/show", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match))
  end

  it "renders attributes" do
    render

    expect(rendered).to have_content(@match.place, count: 1)
    expect(rendered).to have_content(@match.score_home, minimum: 1)
    expect(rendered).to have_content(@match.score_away, minimum: 1)
    expect(rendered).to have_css("a[href='#{team_path(@match.team_home)}']", count: 1)
    expect(rendered).to have_css("a[href='#{team_path(@match.team_away)}']", count: 1)
  end
end

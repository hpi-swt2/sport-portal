require 'rails_helper'

RSpec.describe "matches/show", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match))
  end

  it "renders attributes for simple match" do
    render

    expect(rendered).to have_content(@match.place, count: 1)
    expect(rendered).to have_content(@match.score_home, minimum: 1)
    expect(rendered).to have_content(@match.score_away, minimum: 1)
    expect(rendered).to have_css("a[href='#{team_path(@match.team_home)}']", count: 1)
    expect(rendered).to have_css("a[href='#{team_path(@match.team_away)}']", count: 1)
  end

  it "renders correct link for a match of matches" do
    @match.team_home = FactoryBot.create :match
    @match.team_away = FactoryBot.create :match
    render

    expect(rendered).to have_css("a[href='#{match_path(@match.team_home)}']", count: 1)
    expect(rendered).to have_css("a[href='#{match_path(@match.team_away)}']", count: 1)
  end

  it "renders no participant link when there is no participant" do
    @match.team_home = nil
    @match.team_away = nil
    render

    expect(rendered).to have_content('---', count: 2)
  end
end

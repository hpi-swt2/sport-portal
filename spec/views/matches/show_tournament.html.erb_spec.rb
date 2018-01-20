require 'rails_helper'

RSpec.describe "matches/show", type: :view do
  before(:each) do
    @tournament = FactoryBot.create :tournament, :with_teams
    @tournament.generate_schedule
    @match = assign(:match, @tournament.finale)
  end

  it "renders correct link for a match of matches" do
    @match.team_away.match.points_home = 3
    @match.team_away.match.points_away = 1

    render

    expect(rendered).to have_css("a[href='#{match_path(@match.team_home.match)}']", count: 1)
    expect(rendered).to have_css("a[href='#{team_path(@match.team_away.advancing_participant)}']", count: 1)
  end

end

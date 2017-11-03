require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    @matches = assign(:matches, [
      FactoryBot.create(:match),
      FactoryBot.create(:match)
    ])
  end

  it "renders a list of matches" do
    render

    expect(rendered).to have_content(@matches.first.date.to_s, minimum: 1)

    expect(rendered).to have_content(@matches.first.place, count: 1)
    expect(rendered).to have_content(@matches.second.place, count: 1)

    expect(rendered).to have_content(@matches.first.score_home, minimum: 1)
    expect(rendered).to have_content(@matches.second.score_home, minimum: 1)

    expect(rendered).to have_content(@matches.first.score_away, minimum: 1)
    expect(rendered).to have_content(@matches.second.score_away, minimum: 1)

    expect(rendered).to have_content(@matches.first.team_home.name, count: 1)
    expect(rendered).to have_content(@matches.second.team_home.name, count: 1)

    expect(rendered).to have_content(@matches.first.team_away.name, count: 1)
    expect(rendered).to have_content(@matches.second.team_away.name, count: 1)
  end
end

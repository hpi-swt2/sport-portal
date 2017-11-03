require 'rails_helper'

RSpec.describe "matches/show", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match))
  end

  it "renders attributes" do
    render

    expect(rendered).to have_content(@match.date.to_s, count: 1)
    expect(rendered).to have_content(@match.place, count: 1)
    expect(rendered).to have_content(@match.score_home, minimum: 1)
    expect(rendered).to have_content(@match.score_away, minimum: 1)
    expect(rendered).to have_content(@match.team_home.name, minimum: 1)
    expect(rendered).to have_content(@match.team_away.name, minimum: 1)
  end
end

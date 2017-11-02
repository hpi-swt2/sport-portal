require 'rails_helper'

RSpec.describe "matches/show", type: :view do
  before(:each) do
    @match = assign(:match, Match.create!(
      :place => "Place",
      :team_home => nil,
      :team_away => nil,
      :score_home => 2,
      :score_away => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Place/)
    expect(rendered).to match(//)
    expect(rendered).to match(//)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end

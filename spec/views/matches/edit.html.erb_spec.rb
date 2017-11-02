require 'rails_helper'

RSpec.describe "matches/edit", type: :view do
  before(:each) do
    @match = assign(:match, Match.create!(
      :place => "MyString",
      :team_home => nil,
      :team_away => nil,
      :score_home => 1,
      :score_away => 1
    ))
  end

  it "renders the edit match form" do
    render

    assert_select "form[action=?][method=?]", match_path(@match), "post" do

      assert_select "input#match_place[name=?]", "match[place]"

      assert_select "input#match_team_home_id[name=?]", "match[team_home_id]"

      assert_select "input#match_team_away_id[name=?]", "match[team_away_id]"

      assert_select "input#match_score_home[name=?]", "match[score_home]"

      assert_select "input#match_score_away[name=?]", "match[score_away]"
    end
  end
end

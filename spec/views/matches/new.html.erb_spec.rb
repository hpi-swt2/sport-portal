require 'rails_helper'

RSpec.describe "matches/new", type: :view do
  before(:each) do
    assign(:match, Match.new(
      :place => "MyString"
    ))
  end
  it "renders new match form" do
    render

    assert_select "form[action=?][method=?]", matches_path, "post" do

      assert_select "input#match_place[name=?]", "match[place]"

      assert_select "select#match_team_home_id[name=?]", "match[team_home_id]"

      assert_select "select#match_team_away_id[name=?]", "match[team_away_id]"

      assert_select "input#match_score_home[name=?]", "match[score_home]"

      assert_select "input#match_score_away[name=?]", "match[score_away]"
    end
  end
end

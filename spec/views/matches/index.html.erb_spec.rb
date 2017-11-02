require 'rails_helper'

RSpec.describe "matches/index", type: :view do
  before(:each) do
    assign(:matches, [
      Match.create!(
        :place => "Place",
        :team_home => nil,
        :team_away => nil,
        :score_home => 2,
        :score_away => 3
      ),
      Match.create!(
        :place => "Place",
        :team_home => nil,
        :team_away => nil,
        :score_home => 2,
        :score_away => 3
      )
    ])
  end

  it "renders a list of matches" do
    render
    assert_select "tr>td", :text => "Place".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => 3.to_s, :count => 2
  end
end

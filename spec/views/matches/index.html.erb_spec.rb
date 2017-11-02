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
    assert_select "tr>td", :text => @matches.first.place.to_s, :count => 2
    assert_select "tr>td", :text => @matches.first.date.to_s, :count => 2
    assert_select "tr>td", :text => @matches.first.score_home.to_s, :count => 2
    assert_select "tr>td", :text => @matches.first.score_away.to_s, :count => 2
  end
end

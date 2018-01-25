require 'rails_helper'

RSpec.describe "matches/new", type: :view do
  before(:each) do
    assign(:match, FactoryBot.build(:match))
  end
  it "renders new match form" do
    render
    expect(rendered).to have_css("form[action='#{matches_path}'][method='post']", count: 1)
  end

end

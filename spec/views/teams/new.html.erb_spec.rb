require 'rails_helper'

RSpec.describe "teams/new", type: :view do
  before(:each) do
    assign(:team, FactoryBot.build(:team))
  end

  it "renders new team form" do
    render
    expect(rendered).to have_css("form[action='#{teams_path}'][method='post']", count: 1)
  end
end

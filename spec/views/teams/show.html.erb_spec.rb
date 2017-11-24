require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, FactoryBot.create(:team))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_content(@team.name, count: 1)
    expect(rendered).to have_content(@team.kind_of_sport, count: 1)
    expect(rendered).to have_content(@team.description, count: 1)
  end
end

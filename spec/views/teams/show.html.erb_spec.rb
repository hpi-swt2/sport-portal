require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, FactoryBot.create(:team))
  end

  it "renders attributes" do
    render
    expect(rendered).to have_content(@team.name, count: 1)
  end

  it " shows assign ownership button for mere members" do
    user = FactoryBot.create :user    
    @team.members << user
    render
    rendered.should have_content('Assign Ownership')
  end

  it "does not show delete ownership button for mere members" do
    user = FactoryBot.create :user    
    @team.members << user
    render
    rendered.should_not have_content('Delete Ownership')
  end

  it "shows delete ownership button for owners" do
    user = FactoryBot.create :user    
    @team.members << user
    @team.owners << user
    render
    rendered.should have_content('Delete Ownership')
  end

  it "does not show assign ownership button for owners" do
    user = FactoryBot.create :user    
    @team.members << user
    @team.owners << user
    render
    rendered.should_not have_content('Assign Ownership')
  end
end

require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, FactoryBot.create(:team))
    @user = FactoryBot.create :user    
  end

  it "renders attributes" do
    render
    expect(rendered).to have_content(@team.name, count: 1)
    expect(rendered).to have_content(@team.kind_of_sport, count: 1)
    expect(rendered).to have_content(@team.description, count: 1)
  end

  it "shows assign ownership button for mere members" do
    sign_in @user
    @team.owners << @user
    another_user = FactoryBot.create :user    
    @team.members << another_user
    render
    rendered.should have_content(t("helpers.links.assign_ownership"))
  end

  it "does not show delete ownership button for mere members" do
    user = FactoryBot.create :user    
    @team.owners = []
    render
    rendered.should_not have_content(t("helpers.links.delete_ownership"))
  end

  it "shows delete ownership button for owners" do
    sign_in @user
    @team.owners << @user    
    another_user = FactoryBot.create :user    
    @team.owners << another_user
    render
    rendered.should have_content(t("helpers.links.delete_ownership"))
  end

  it "does not show assign ownership button for owners" do
    user = FactoryBot.create :user    
    @team.members << @user
    @team.owners = @team.members    
    render
    rendered.should_not have_content(t("helpers.links.assign_ownership"))
  end
end

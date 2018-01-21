require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  before(:each) do
    @teams = assign(:teams, [
      FactoryBot.create(:team),
      FactoryBot.create(:team)
    ])
    @user = FactoryBot.create(:user)
    @admin = FactoryBot.create(:admin)
  end

  it "renders a list of teams" do
    render
    expect(rendered).to have_content(@teams.first.name, count: 1)
    expect(rendered).to have_content(@teams.second.name, count: 1)
  end

  it "doesn't render the new button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('teams.index.create_team'))
  end

  it "show my teams if the users has teams" do
    sign_in @user
    @user.teams.push @teams[0]
    render
    expect(rendered).to have_text(t('teams.index.my_teams'))
  end

  it "show my teams if the users has teams" do
    sign_in @user
    render
    expect(rendered).to_not have_text(t('teams.index.my_teams'))
  end

  it "renders the new button when signed in" do
    sign_in @user
    render
    expect(rendered).to have_selector(:link_or_button, t('teams.index.create_team'))
  end
end

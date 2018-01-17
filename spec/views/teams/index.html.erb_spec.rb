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
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.new'))
  end

  it "doesn't render the edit button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "doesn't render the edit button when signed in and you dont have a team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when signed in and you dont have a team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "renders the new button when signed in" do
    sign_in @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.new'))
  end

  it "renders the edit button when signed in and you are an admin" do
    sign_in @admin
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "renders the delete button when signed in and you are an admin" do
    sign_in @admin
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "renders the filter select input field when user is signed in" do
    sign_in @user
    render
    expect(rendered).to have_select('filter')
  end

  it "doesn't render the filter select input field when user is not signed in" do
    render
    expect(rendered).to_not have_select('filter')
  end


end

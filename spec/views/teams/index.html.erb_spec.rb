require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  before(:each) do
    @teams = assign(:teams, [
      FactoryBot.create(:team),
      FactoryBot.create(:team)
    ])
    @user = FactoryBot.create(:user)
  end

  it "renders a list of teams" do
    render
    expect(rendered).to have_content(@teams.first.name, count: 1)
    expect(rendered).to have_content(@teams.second.name, count: 1)
  end

  it "doesn't render the new button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, 'New')
  end

  it "doesn't render the edit button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Edit')
  end

  it "doesn't render the delete button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Delete')
  end

  it "doesn't render the edit button when signed in and you dont have a team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Edit')
  end

  it "doesn't render the delete button when signed in and you dont have a team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Delete')
  end

  it "renders the new button when signed in" do
    sign_in @user
    render
    expect(rendered).to have_selector(:link_or_button, 'New')
  end

  it "renders the edit button when signed in and you have teams" do
    sign_in @user
    @teams[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, 'Edit')
  end

  it "renders the delete button when signed in and you have teams " do
    sign_in @user
    @teams[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, 'Delete')
  end
  

end

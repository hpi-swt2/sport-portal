require 'rails_helper'

RSpec.describe "teams/show", type: :view do
  before(:each) do
    @team = assign(:team, FactoryBot.create(:team))
    @user = FactoryBot.build(:user)
    FactoryBot.build(:user)
  end

  it "renders attributes" do
    render
    expect(rendered).to have_content(@team.name, count: 1)
    expect(rendered).to have_content(@team.kind_of_sport, count: 1)
    expect(rendered).to have_content(@team.description, count: 1)
  end

  it "does not show delete ownership button for mere members" do
    user = FactoryBot.create :user
    @team.owners = []
    render
    rendered.should_not have_content(t("helpers.links.delete_ownership"))
  end

  it "does not show assign ownership button for owners" do
    user = FactoryBot.create :user
    @team.members << @user
    @team.owners = @team.members
    render
    rendered.should_not have_content(t("helpers.links.assign_ownership"))
  end


  it "doesn't render the edit button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "doesn't render the edit button when it's not your team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when it's not your team" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end
end

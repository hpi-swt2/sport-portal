require 'rails_helper'

describe "Index team page", type: :feature do

  it "should render without an error" do
    visit teams_path
  end

  it "should only show teams current user is member of if filter is set" do
    @team = FactoryBot.create :team
    @team.name = "First"
    @team.save

    @another_team = FactoryBot.create :team
    @another_team.name = "Second"
    @another_team.save

    @user = FactoryBot.create :user
    @team.members << @user
    sign_in @user

    visit teams_path(filter: "true")

    expect(page).to have_text("First")
    expect(page).to_not have_text("Second")
  end

  it "should not contain an id column" do
    @team = FactoryBot.create :team
    visit teams_path
    expect(page).to_not have_text Team.human_attribute_name :id
  end
end

require 'rails_helper'

describe "Index team page", type: :feature do

  it "should render without an error" do
    visit teams_path
  end

  it "should have a select box to filter teams" do
    visit teams_path
    expect(page).to have_select('filter')
  end

  it "should get " do
    @team = FactoryBot.create :team
    @team.name = "First"
    @team.save

    @another_team = FactoryBot.create :team
    @another_team.name = "Second"
    @another_team.save
    
    @user = FactoryBot.create :user
    @team.members << @user
    sign_in @user

    visit teams_path(filter: I18n.t("helpers.teams.show_mine"))

    expect(page).to have_text("First")
    expect(page).to_not have_text("Second")
  end
end
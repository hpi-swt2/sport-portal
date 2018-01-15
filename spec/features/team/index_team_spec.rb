require 'rails_helper'

describe "Index team page", type: :feature do

  it "should render without an error" do
    visit teams_path
  end

  it "should not contain an id column" do
    @team = FactoryBot.create :team
    visit teams_path
    expect(page).to_not have_text Team.human_attribute_name :id
  end
end

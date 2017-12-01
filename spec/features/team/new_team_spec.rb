require'rails_helper'

describe "New team page", type: :feature do

  it "should render without an error" do
    visit new_team_path
  end

end
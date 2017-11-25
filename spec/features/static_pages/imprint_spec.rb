require'rails_helper'

describe "static imprint page", type: :feature do

  it "should render without an error" do
    visit imprint_path
  end

end
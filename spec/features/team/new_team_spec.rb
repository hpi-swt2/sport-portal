require 'rails_helper'

describe "New team page", type: :feature do

  it "should render without an error" do
    visit new_team_path
  end

  it "should notify users about mandatory fields" do
    @user = FactoryBot.create :user
    sign_in @user
    visit new_team_path
    expect(page).to have_text I18n.t('helpers.fields.mandatory')
  end
end

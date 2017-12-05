require 'rails_helper'

RSpec.describe "users/edit_profile", type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user))
    # Devise helper to sign_in user
    # https://github.com/plataformatec/devise#test-helpers
    sign_in @user
  end

  it "has fields for birthday, telephone number, telegram username and favourite sports" do
    render
    expect(rendered).to have_field('user_birthday')
    expect(rendered).to have_field('user_telephone_number')
    expect(rendered).to have_field('user_telegram_username')
    expect(rendered).to have_field('user_favourite_sports')
  end

  it "has a submit button" do
    render
    expect(rendered).to have_xpath('//input[@type="submit"]')
  end

  it "displays existing informations in the fields" do
    render
    expect(rendered).to have_xpath("//input[@value=\"#{@user.telephone_number}\"]", count: 1)
    expect(rendered).to have_xpath("//input[@value=\"#{@user.telegram_username}\"]", count: 1)
    expect(rendered).to have_xpath("//input[@value=\"#{@user.favourite_sports}\"]", count: 1)
  end
end

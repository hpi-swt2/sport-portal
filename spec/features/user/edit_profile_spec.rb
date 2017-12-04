require "rails_helper"

RSpec.feature "Edit profile", :type => :feature do
  scenario "User edits profile informations" do
    user = FactoryBot.create :user
    sign_in user
    visit user_profile_edit_path(user)

    new_params = FactoryBot.attributes_for(:user)
    new_params[:birthday] = new_params[:birthday] - 1.year
    new_params[:telephone_number] = "01541567233"
    new_params[:telegram_username] = new_params[:telegram_username] + "_new"
    new_params[:favourite_sports] = new_params[:favourite_sports] + ", Baseball"

    fill_in "user_birthday", :with => new_params[:birthday]
    fill_in "user_telephone_number", :with => new_params[:telephone_number]
    fill_in "user_telegram_username", :with => new_params[:telegram_username]
    fill_in "user_favourite_sports", :with => new_params[:favourite_sports]
    find('input[type="submit"]').click

    user.reload
    expect(user.birthday).to eq(new_params[:birthday])
    expect(user.telephone_number).to eq(new_params[:telephone_number])
    expect(user.telegram_username).to eq(new_params[:telegram_username])
    expect(user.favourite_sports).to eq(new_params[:favourite_sports])
  end

end

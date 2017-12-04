require "rails_helper"

RSpec.feature "Edit profile", :type => :feature do
  let(:user) { FactoryBot.create :user }

  before(:each) { sign_in user }

  scenario "User edits profile informations" do
    user = FactoryBot.create :user
    visit user_profile_edit_path(user)

    new_params = FactoryBot.attributes_for(:user)
    new_params[:birthday] = new_params[:birthday] - 1.year
    new_params[:telephone_number] = "01541567233"
    new_params[:telegram_username] = new_params[:telegram_username] + "_new"
    new_params[:favourite_sports] = new_params[:favourite_sports] + ", Baseball"

    page.attach_file("user_avatar", "#{Rails.root}/spec/fixtures/valid_avatar.png")
    fill_in "user_birthday", :with => new_params[:birthday]
    fill_in "user_telephone_number", :with => new_params[:telephone_number]
    fill_in "user_telegram_username", :with => new_params[:telegram_username]
    fill_in "user_favourite_sports", :with => new_params[:favourite_sports]
    find('input[type="submit"]').click

    user.reload
    expect(user.avatar.metadata["filename"]).to eq("valid_avatar.png")
    expect(user.birthday).to eq(new_params[:birthday])
    expect(user.telephone_number).to eq(new_params[:telephone_number])
    expect(user.telegram_username).to eq(new_params[:telegram_username])
    expect(user.favourite_sports).to eq(new_params[:favourite_sports])
  end

  scenario "User sees delete checkbox for his avatar" do
    user = FactoryBot.create :user, :with_avatar
    sign_in user
    visit user_profile_edit_path(user)

    expect(page).to have_css("input[id='user_remove_image']")
  end

  scenario "User sees no delete checkbox for his avatar" do
    visit user_profile_edit_path(user)

    expect(page).not_to have_css("input[id='user_remove_image']")
  end

end

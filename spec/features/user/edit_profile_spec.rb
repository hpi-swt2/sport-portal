require "rails_helper"

RSpec.feature "Edit profile", type: :feature do
  let(:user) { FactoryBot.create :user }

  before(:each) { sign_in user }

  scenario "User edits profile informations" do
    visit edit_user_path(user)

    new_params = FactoryBot.attributes_for(:user)
    new_params[:birthday] = new_params[:birthday] - 1.year
    new_params[:telephone_number] = "01541567233"
    new_params[:telegram_username] = new_params[:telegram_username] + "_new"
    new_params[:favourite_sports] = new_params[:favourite_sports] + ", Baseball"
    new_params[:contact_information] = new_params[:contact_information] + " or via letter: 123 Fakestreet, 14482 Potsdam"

    page.attach_file("user_avatar", "#{Rails.root}/spec/fixtures/valid_avatar.png")
    fill_in "user_birthday", with: new_params[:birthday]
    fill_in "user_telephone_number", with: new_params[:telephone_number]
    fill_in "user_telegram_username", with: new_params[:telegram_username]
    fill_in "user_favourite_sports", with: new_params[:favourite_sports]
    fill_in "user_contact_information", with: new_params[:contact_information]
    find('input[type="submit"]').click

    user.reload
    expect(user.avatar.metadata["filename"]).to eq("valid_avatar.png")
    expect(user.birthday).to eq(new_params[:birthday])
    expect(user.telephone_number).to eq(new_params[:telephone_number])
    expect(user.telegram_username).to eq(new_params[:telegram_username])
    expect(user.favourite_sports).to eq(new_params[:favourite_sports])
    expect(user.contact_information).to eq(new_params[:contact_information])
  end

  scenario "User sees delete checkbox for his avatar" do
    user = FactoryBot.create :user, :with_avatar
    sign_in user
    visit edit_user_path(user)

    expect(page).to have_css("input[id='user_remove_avatar']")
  end

  scenario "User sees no delete checkbox for his avatar" do
    visit edit_user_path(user)
    expect(page).not_to have_css("input[id='user_remove_avatar']")
  end

end

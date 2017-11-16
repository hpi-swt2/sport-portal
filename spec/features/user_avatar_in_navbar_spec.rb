RSpec.feature "User avatar in navbar", :type => :feature do
  scenario "User sees his avatar in navbar" do
    user = FactoryBot.create(:user)
    sign_in user
    visit root_path

    expect(page).to have_css(".navbar img[src='#{user.avatar.url(:square)}']")
  end
end

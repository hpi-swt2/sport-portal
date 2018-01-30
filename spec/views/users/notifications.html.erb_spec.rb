require 'rails_helper'

RSpec.describe "users/notifications", type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user))
    sign_in @user
  end

  it "renders headline" do
    render
    expect(rendered).to have_text(I18n.t('view.user.notifications.settings'))
  end
  it "has team notifications checkbox" do
    render
    expect(rendered).to have_field('user_team_notifications_enabled')
  end
  it "has event notifications checkbox" do
    render
    expect(rendered).to have_field('user_event_notifications_enabled')
  end
end

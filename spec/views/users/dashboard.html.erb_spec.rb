require 'rails_helper'

RSpec.describe "devise/registrations/dashboard", type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user))
    sign_in @user
  end

  it "renders headline" do
    render
    expect(rendered).to have_css(
      'h1',
      text: I18n.t('dashboard.title', name: @user.first_name)
    )
  end
end

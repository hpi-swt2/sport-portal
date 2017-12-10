require 'rails_helper'

RSpec.describe "application/_navbar", type: :view do
  it "shows a login button" do
    render
    expect(rendered).to have_link(t('devise.registrations.sign_in'), href: new_user_session_path)
  end
end

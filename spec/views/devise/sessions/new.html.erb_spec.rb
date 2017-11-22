require 'rails_helper'


RSpec.describe "devise/sessions/new", type: :view do
  it "should show a link to sin up page" do
    render
    expect(rendered).to have_link(t('devise.registrations.sign_up'), href: new_user_registration_path)
  end
end
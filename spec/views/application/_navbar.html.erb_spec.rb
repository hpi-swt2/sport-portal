require 'rails_helper'

RSpec.describe "application/_navbar", type: :view do
  it "shows the application name" do
    render
    expect(rendered).to have_css '.navbar-brand span', text: I18n.t('appname')
  end

  it "shows a login button" do
    render
    expect(rendered).to have_link(href: new_user_session_path)
  end
end

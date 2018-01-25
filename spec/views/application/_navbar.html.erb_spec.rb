require 'rails_helper'

RSpec.describe "application/_navbar", type: :view do
  it "shows the application name" do
    render
    expect(rendered).to have_link I18n.t('appname'), href: root_path
  end

  it "shows a login button" do
    render
    expect(rendered).to have_link(href: new_user_session_path)
  end
end

require 'rails_helper'

RSpec.describe "devise/registrations/index", type: :view do
  before(:each) do
    @users = assign(:users, [
      FactoryBot.create(:user),
      FactoryBot.create(:user)
    ])
  end

  it "renders a list of users last names" do
    render

    expect(rendered).to have_content(@users.first.last_name, count: 1)
    expect(rendered).to have_content(@users.second.last_name, count: 1)
  end
end

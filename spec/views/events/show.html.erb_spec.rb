require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @user = FactoryBot.create(:user)

    @event = assign(:event, Event.create!(
      :name => "Name",
      :description => "MyText",
      :gamemode => "Gamemode",
      :sport => "Sport",
      :teamsport => false,
      :playercount => 2,
      :gamesystem => "MyText",
      :creator => FactoryBot.create(:user)
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Gamemode/)
    expect(rendered).to match(/Sport/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/MyText/)
  end

  it "renders styled buttons" do
    sign_in @user
    @event.creator = @user
    render
    expect(rendered).to have_css('a.btn.btn-default', :count => 2)
    expect(rendered).to have_css('a.btn.btn-danger')
  end

  #not signed in user
  it "doesn't render the new button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, 'New')
  end

  it "doesn't render the edit button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Edit')
  end

  it "doesn't render the delete button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Delete')
  end

  it "doesn't render the edit button when the event doesn´t belong to the user" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Edit')
  end

  it "doesn't render the delete button when the event doesn´t belong to the user" do
    sign_in @user
    expect(rendered).to_not have_selector(:link_or_button, 'Delete')
  end
end

require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @events =  [
      Event.create!(
        :name => "Name",
        :description => "MyText",
        :gamemode => "Gamemode",
        :sport => "Sport",
        :teamsport => false,
        :playercount => 2,
        :gamesystem => "Gamesystem",
        :deadline => Date.new(2017,12,20),
        :creator => FactoryBot.build(:user)
      ),
      Event.create!(
        :name => "Name",
        :description => "MyText",
        :gamemode => "Gamemode",
        :sport => "Sport",
        :teamsport => false,
        :playercount => 2,
        :gamesystem => "Gamesystem2",
        :deadline => Date.new(2017,12,20),
        :creator => FactoryBot.build(:user)
      )
    ]
    @user = FactoryBot.build(:user)
  end

  it "renders a list of events" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Gamemode".to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Gamesystem".to_s, :count => 1
    assert_select "tr>td", :text => "Gamesystem2".to_s, :count => 1
   end

  it "renders styled buttons" do
    render
    expect(rendered).to have_css('a.btn.btn-default.btn-xs')
    expect(rendered).to have_css('a.btn.btn-danger.btn-xs')
    expect(rendered).to have_css('a.btn.btn-primary')
  end

  it "renders a striped table" do
    render
    expect(rendered).to have_css('table.table-striped')
  end

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

  it "doesn't render the edit button when signed in and you dont have a event" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Edit')
  end

  it "doesn't render the delete button when signed in and you dont have a event" do
    sign_in @user
    render
    expect(rendered).to_not have_selector(:link_or_button, 'Delete')
  end

  it "renders the new button when signed in" do
    sign_in @user
    @events[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, 'New')
  end

  it "renders the edit button when signed in" do
    sign_in @user
    @events[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, 'Edit')
  end

  it "renders the delete button when signed in" do
    sign_in @user
    @events[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, 'Delete')
  end

end

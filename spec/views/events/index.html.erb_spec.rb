require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @events = assign(:events, [
      # Using all three kinds of events, don't use general event because checking if a player can join
      # is a subclass responsibility
      FactoryBot.create(:league),
      FactoryBot.create(:rankinglist),
      FactoryBot.create(:tournament)
      ])
    @user = FactoryBot.create :user
    @other_user = FactoryBot.create :user

    @events.first.editors << @user
    @events.first.owner = @user
    @events.second.owner = @user
    @events.last.editors << @user
  end

  it "renders a list of events" do
     render
   end

  it "renders styled buttons" do
    sign_in @events[0].owner
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
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.new'))
  end

  it "doesn't render the edit button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when not signed in" do
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "doesn't render the edit button when signed in and you dont have a event" do
    sign_in @other_user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "doesn't render the delete button when signed in and you dont have a event" do
    sign_in @other_user
    render
    expect(rendered).to_not have_selector(:link_or_button, t('helpers.links.destroy'))
  end

  it "renders the new button when signed in" do
    sign_in @user
    @events[1].owner = @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.new'))
  end

  it "renders the edit button when signed in" do
    sign_in @user
    @events[1].owner = @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "renders the delete button when signed in" do
    sign_in @user
    @events[1].owner = @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.destroy'))
  end
  it "renders a checkbox to show all events" do
    render
    expect(rendered).to have_field('shown_events')
  end
end

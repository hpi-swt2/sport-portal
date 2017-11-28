require 'rails_helper'

RSpec.describe "events/index", type: :view do
  before(:each) do
    @events = assign(:events, [
      FactoryBot.create(:event),
      FactoryBot.create(:event)
      ])
    @user = FactoryBot.create :user
    sign_in @user

    @events.first.editors << @user
    @events.first.creator = @user
    @events.second.creator = @user
    @events.last.editors << @user
  end

  it "renders a list of events" do
    render
    #FIXME: to be implemented
   end

  it "renders styled buttons" do
    sign_in @events[0].creator
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
    @events[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.new'))
  end

  it "renders the edit button when signed in" do
    @events[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.edit'))
  end

  it "renders the delete button when signed in" do
    @events[1].creator = @user
    render
    expect(rendered).to have_selector(:link_or_button, t('helpers.links.destroy'))
  end
end

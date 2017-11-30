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
    @events.last.editors << @user
  end

  it "renders a list of events" do
    render
    #FIXME: to be implemented
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

  it "renders a checkbox to show all events" do
    render 
    expect(rendered).to have_field('shown_events')
  end
end

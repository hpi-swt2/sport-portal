require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryBot.create(:event))
    @user = FactoryBot.create :user
    sign_in @user
    @event.editors << @user
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content(@event.name)
    expect(rendered).to have_content(@event.description)
    expect(rendered).to have_content(@event.game_mode)
    expect(rendered).to have_content(@event.discipline)
    expect(rendered).to have_content(@event.deadline)
    expect(rendered).to have_content(@event.startdate)
    expect(rendered).to have_content(@event.enddate)
  end

  it "renders an edit button for organizers" do
    render
  end

  it "renders styled buttons" do
    render
    expect(rendered).to have_css('a.btn.btn-default', :count => 2)
    expect(rendered).to have_css('a.btn.btn-danger')
  end
end

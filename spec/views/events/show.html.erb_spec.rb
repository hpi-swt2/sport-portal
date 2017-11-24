require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryBot.create(:event))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to have_content(@event.name)
    expect(rendered).to have_content(@event.description)
    expect(rendered).to have_content(@event.gamemode)
    expect(rendered).to have_content(@event.sport)
    expect(rendered).to have_content(@event.teamsport)
    expect(rendered).to have_content(@event.playercount)
    expect(rendered).to have_content(@event.gamesystem)
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

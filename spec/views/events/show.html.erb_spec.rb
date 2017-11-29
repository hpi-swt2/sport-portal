require 'rails_helper'

RSpec.describe "events/show", type: :view do
  before(:each) do
    @event = assign(:event, FactoryBot.create(:event))
    @user = FactoryBot.create :user
    sign_in @user
    @event = FactoryBot.create :event, player_type: Event.player_types[:single]

    @event.editors << @user
  end

  it "renders attributes in <p>" do
    render
    #FIXME: To be implemented
  end

  it "renders styled buttons" do
    render
    expect(rendered).to have_content(t('events.show.to_schedule'))
  end
end

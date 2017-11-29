require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    @user = FactoryBot.create :user
    sign_in @user
    @event = assign(:event, FactoryBot.create(:event))
    @event.editors << @user
  end

  it "renders the edit event form" do
    render

    assert_select "form[action=?][method=?]", event_path(@event), "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "input[name=?]", "event[game_mode]"

      assert_select "input[name=?]", "event[discipline]"

      assert_select "input[name=?]", "event[deadline]"

      assert_select "input[name=?]", "event[startdate]"

      assert_select "input[name=?]", "event[enddate]"

    end
  end
end

require 'rails_helper'

RSpec.describe "events/new", type: :view do
  before(:each) do
    assign(:event, FactoryBot.build(:event))
  end

  it "renders new event form" do
    render

    assert_select "form[action=?][method=?]", events_path, "post" do

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

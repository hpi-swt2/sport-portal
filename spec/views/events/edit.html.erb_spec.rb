require 'rails_helper'

RSpec.describe "events/edit", type: :view do
  before(:each) do
    assign(:event, FactoryBot.build(:event))
  end

  it "renders the edit event form" do
      render

      assert_select "form[action=?][method=?]", events_path, "post" do

      assert_select "input[name=?]", "event[name]"

      assert_select "textarea[name=?]", "event[description]"

      assert_select "select[name=?]", "event[type]"

      assert_select "select[name=?]", "event[game_mode]"

      assert_select "input[name=?]", "event[discipline]"

      assert_select "input[name=?]", "event[deadline]"

      assert_select "input[name=?]", "event[startdate]"

      assert_select "input[name=?]", "event[enddate]"

        end
  end
end
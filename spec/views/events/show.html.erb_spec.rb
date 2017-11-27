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
    #FIXME: To be implemented
  end

  it "renders styled buttons" do
    render
    expect(rendered).to have_css('a.btn.btn-default', :count => 2)
    expect(rendered).to have_css('a.btn.btn-danger')
  end
end

require 'rails_helper'

RSpec.describe "layouts/application", type: :view do
  it "renders a footer" do
    render
    expect(rendered).to have_css('footer')
  end
end

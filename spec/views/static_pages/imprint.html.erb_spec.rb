require 'rails_helper'

RSpec.describe "static_pages/imprint", type: :view do
  it "renders headline" do
    render
    expect(rendered).to have_css('h1')
  end
end

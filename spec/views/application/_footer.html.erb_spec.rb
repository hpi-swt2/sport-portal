require 'rails_helper'

RSpec.describe "application/_footer", type: :view do
  it "has link to imprint" do
    render
    expect(rendered).to have_link(href: static_page_path(:imprint))
  end

  it "has link to hpi.de" do
    render
    expect(rendered).to have_link(href: 'https://hpi.de/')
  end
end

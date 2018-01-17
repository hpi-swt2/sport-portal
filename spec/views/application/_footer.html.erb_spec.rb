require 'rails_helper'

RSpec.describe "application/_footer", type: :view do
  it "has link to imprint" do
    render
    expect(rendered).to have_link I18n.t('footer.imprint'), href: imprint_path
  end

  it "has link to hpi.de" do
    render
    expect(rendered).to have_link I18n.t('footer.hpi'),  href: 'https://hpi.de/'
  end
end

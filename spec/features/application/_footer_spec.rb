require'rails_helper'

describe "footer", type: :feature do

  it "should have link to imprint" do
    visit root_path
    click_on I18n.t('imprint')
    expect(page).to have_css('h1', text: I18n.t('imprint'))
  end

end
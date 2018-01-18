require 'rails_helper'

describe "static imprint page", type: :feature do

  it "should render without an error" do
    visit imprint_path
  end

  it "should have three sections" do
    visit imprint_path
    expect(page).to have_selector('section', count: 3)
  end

  it "should contain a headline and a body for each section" do
    visit imprint_path
    page.all('section').each do |section|
      expect(section).to have_selector('strong', count: 1)
      expect(section).to have_selector('p', count: 1)
    end
  end

  it "should contain information on contact details" do
    visit imprint_path
    expect(page).to have_css('strong', text: I18n.t('imprint.contact.head'))
  end

  it "should contain information on manager details" do
    visit imprint_path
    expect(page).to have_css('strong', text: I18n.t('imprint.manager.head'))
  end

  it "should contain information on legal notices" do
    visit imprint_path
    expect(page).to have_css('strong', text: I18n.t('imprint.legal-notice.head'))
  end

end

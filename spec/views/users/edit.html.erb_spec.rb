require 'rails_helper'

RSpec.describe 'users/edit', type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user))
    # Devise helper to sign_in user
    # https://github.com/plataformatec/devise#test-helpers
    sign_in @user
  end

  it 'has fields for birthday, telephone number, telegram username, favourite sports and contact information' do
    render
    expect(rendered).to have_field('user_birthday')
    expect(rendered).to have_field('user_telephone_number')
    expect(rendered).to have_field('user_telegram_username')
    expect(rendered).to have_field('user_favourite_sports')
    expect(rendered).to have_field('user_contact_information')
  end

  it 'has a submit button' do
    render
    expect(rendered).to have_xpath('//input[@type="submit"]')
  end

  it 'displays existing informations in the fields' do
    render
    expect(rendered).to have_xpath("//input[@value=\"#{@user.telephone_number}\"]", count: 1)
    expect(rendered).to have_xpath("//input[@value=\"#{@user.telegram_username}\"]", count: 1)
    expect(rendered).to have_xpath("//input[@value=\"#{@user.favourite_sports}\"]", count: 1)
    expect(rendered).to have_xpath("//input[@value=\"#{@user.contact_information}\"]", count: 1)
  end

  it "renders notification subtitle" do
    render
    expect(rendered).to have_text(I18n.t('users.edit.notifications.subtitle'))
  end
  it "has team notifications checkbox" do
    render
    expect(rendered).to have_field('user_team_notifications_enabled')
  end
  it "has event notifications checkbox" do
    render
    expect(rendered).to have_field('user_event_notifications_enabled')
  end
end

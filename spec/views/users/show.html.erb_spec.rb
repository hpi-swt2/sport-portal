require 'rails_helper'

RSpec.describe 'devise/registrations/show', type: :view do
  before(:each) do
    @user = assign(:user, FactoryBot.create(:user))
    # Devise helper to sign_in user
    # https://github.com/plataformatec/devise#test-helpers
    sign_in @user
  end

  it 'renders attributes' do
    render
    expect(rendered).to have_content(@user.first_name, count: 1)
    expect(rendered).to have_content(@user.last_name, count: 1)
  end

  it 'displays contact information if available' do
    contact_information = 'My homepage: foo-bar.com (check it out! :D)'
    @user.contact_information = contact_information
    render
    expect(rendered).to have_content(I18n.t('activerecord.attributes.user.contact_information'), count: 1)
    expect(rendered).to have_content(contact_information, count: 1)
  end

  it 'does not show any contact information if none is available' do
    @user.contact_information = nil
    render
    expect(rendered).to have_content(I18n.t('activerecord.attributes.user.contact_information'), count: 0)
  end
end

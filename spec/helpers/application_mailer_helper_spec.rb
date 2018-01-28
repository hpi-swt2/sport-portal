require 'rails_helper'

RSpec.describe ApplicationMailerHelper, type: :helper do
  it 'should produce pretty to-fields for emails' do
    user = FactoryBot.create :user
    user.first_name = 'Hans'
    user.last_name = 'Mueller'
    user.email = 'hans@example.org'
    email_with_name = helper.email_with_name(user)
    expect(email_with_name).to eq("'Hans Mueller' <hans@example.org>")
  end
end

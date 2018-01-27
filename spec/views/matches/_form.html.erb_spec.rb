require 'rails_helper'

RSpec.describe "matches/_form", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match, :with_results))
  end

  it "renders a input form" do
    render partial: "form", locals: { is_creation_form: false }

    expect(rendered).to have_css("form[action='#{match_path(@match)}'][method='post']", count: 1)
  end

end

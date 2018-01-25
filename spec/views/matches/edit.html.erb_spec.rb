require 'rails_helper'

RSpec.describe "matches/edit", type: :view do
  before(:each) do
    @match = assign(:match, FactoryBot.create(:match))
  end

  it "renders the edit match form" do
    render
    expect(rendered).to have_css("form[action='#{match_path(@match)}'][method='post']", count: 1)
  end

  it "renders the partial with the correct local is_creation_form" do
    render
    expect(response).to render_template(partial: "_form", locals: { is_creation_form: false })
  end

end

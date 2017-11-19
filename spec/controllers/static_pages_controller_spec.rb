require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #show imprint" do
    it "returns http success" do
      get :show, params: { static_page: :imprint }
      expect(response).to have_http_status(:success)
    end
  end

end

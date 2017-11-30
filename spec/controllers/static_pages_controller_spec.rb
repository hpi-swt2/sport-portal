require 'rails_helper'

RSpec.describe StaticPagesController, type: :controller do

  describe "GET #imprint" do
    it "returns http success" do
      get :imprint, params: {}
      expect(response).to have_http_status(:success)
    end
  end

end

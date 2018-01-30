require 'rails_helper'

RSpec.describe ErrorsController, type: :controller do

  describe "GET #not_found" do
    it "returns http status not found" do
      get :not_found
      expect(response).to have_http_status(:not_found)
    end
  end

end

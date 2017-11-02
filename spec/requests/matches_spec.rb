require 'rails_helper'

RSpec.describe "Matches", type: :request do
  describe "GET /matches" do
    it "works! (now write some real specs)" do
      get matches_path
      expect(response).to have_http_status(200)
    end
  end
end

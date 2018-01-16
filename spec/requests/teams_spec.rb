require 'rails_helper'

RSpec.describe "Teams", type: :request do
  describe "GET /teams" do
    it "should work" do
      get teams_path
      expect(response).to have_http_status(200)
    end
  end
end

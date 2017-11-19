require "rails_helper"

RSpec.describe AvatarsController, type: :routing do
  describe "routing" do

    it "routes to #update" do
      expect(:put => "/users/1/avatar").to route_to("avatars#update", :id => "1")
    end

    it "routes to #update" do
      expect(:patch => "/users/1/avatar").to route_to("avatars#update", :id => "1")
    end
  
    it "routes to #destroy" do
      expect(:delete => "/users/1/avatar").to route_to("avatars#destroy", :id => "1")
    end
  end
end

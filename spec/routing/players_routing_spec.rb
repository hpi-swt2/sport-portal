require "rails_helper"

RSpec.describe PlayersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/players").to route_to("players#index")
    end

    it "routes to #new" do
      expect(:get => "/players/new").to route_to("players#new")
    end

    it "routes to #show" do
      expect(:get => "/players/1").to route_to("players#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/players/1/edit").to route_to("players#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/players").to route_to("players#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/players/1").to route_to("players#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/players/1").to route_to("players#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/players/1").to route_to("players#destroy", :id => "1")
    end

  end
end

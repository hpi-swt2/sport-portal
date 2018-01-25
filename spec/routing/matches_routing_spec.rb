require "rails_helper"

RSpec.describe MatchesController, type: :routing do
  describe "routing" do

    it "routes to #new" do
      expect(get: "/matches/new").to route_to("matches#new")
    end

    it "routes to #show" do
      expect(get: "/matches/1").to route_to("matches#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/matches/1/edit").to route_to("matches#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/matches").to route_to("matches#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/matches/1").to route_to("matches#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/matches/1").to route_to("matches#update", id: "1")
    end

    it "routes to #update_poinst via PUT" do
      expect(put: "/matches/1/update_points").to route_to("matches#update_points", id: "1")
    end

    it "routes to #update_poinst via PATCH" do
      expect(put: "/matches/1/update_points").to route_to("matches#update_points", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/matches/1").to route_to("matches#destroy", id: "1")
    end

    it "routes to #add_game_result" do
      expect(get: "/matches/1/add_game_result").to route_to("matches#add_game_result", id: "1")
    end

    it "routes to #remove_game_result" do
      expect(get: "/matches/1/remove_game_result/1").to route_to("matches#remove_game_result", id: "1", result_id: "1")
    end

  end
end

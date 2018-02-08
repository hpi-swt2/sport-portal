require "rails_helper"

RSpec.describe EventsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/events").to route_to("events#index")
    end

    it "routes to #new" do
      expect(get: "/events/new").to route_to("events#new")
      expect(get: "/tournaments/new").to route_to("events#new", type: Tournament)
      expect(get: "/leagues/new").to route_to("events#new", type: League)
    end

    it "routes to #show" do
      expect(get: "/events/1").to route_to("events#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/events/1/edit").to route_to("events#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/events").to_not be_routable
      expect(post: "/tournaments").to route_to("events#create", type: Tournament)
      expect(post: "/leagues").to route_to("events#create", type: League)
    end

    it "routes to #update via PUT" do
      expect(put: "/events/1").to route_to("events#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/events/1").to route_to("events#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/events/1").to route_to("events#destroy", id: "1")
    end

    it "routes to #schedule" do
      expect(get: "/events/1/schedule").to route_to("events#schedule", id: "1")
    end

    it "routes to #join" do
      expect(put: "/events/1/join").to route_to("events#join", id: "1")
    end

    it "routes to #leave" do
      expect(put: "/events/1/leave").to route_to("events#leave", id: "1")
    end

    it "doesn't route to #ranking" do
      expect(get: "/events/1/ranking").to_not route_to("events#ranking", id: "1")
    end
  end
end

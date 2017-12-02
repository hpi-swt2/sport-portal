require "rails_helper"

RSpec.describe TeamsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(get: "/teams").to route_to("teams#index")
    end

    it "routes to #new" do
      expect(get: "/teams/new").to route_to("teams#new")
    end

    it "routes to #show" do
      expect(get: "/teams/1").to route_to("teams#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/teams/1/edit").to route_to("teams#edit", id: "1")
    end

    it "routes to #create" do
      expect(post: "/teams").to route_to("teams#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/teams/1").to route_to("teams#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/teams/1").to route_to("teams#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/teams/1").to route_to("teams#destroy", id: "1")
    end

    it "routes to #assign_ownership" do
      expect(post: "/teams/1/assign_ownership?team_member=1").to route_to("teams#assign_ownership", id: "1", team_member: "1")
    end

    it "routes to #delete_ownership" do
      expect(post: "/teams/1/delete_ownership?team_member=1").to route_to("teams#delete_ownership", id: "1", team_member: "1")
    end

    it "routes to #delete_membership" do
      expect(post: "/teams/1/delete_membership?team_member=1").to route_to("teams#delete_membership", id: "1", team_member: "1")
    end

  end
end

class LeaguesController < EventsController
  # GET /events/1/ranking
  def ranking
    @ranking_entries = @event.get_ranking
  end

end

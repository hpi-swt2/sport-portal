# This controller extends the league type of events to be capable of showing a ranking entry
class LeaguesController < EventsController
  # GET /leagues/1/ranking
  def ranking
    @ranking_entries = @event.get_ranking
  end
end

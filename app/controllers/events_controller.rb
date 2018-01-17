class EventsController < ApplicationController
  RankingEntry = Struct.new(:rank, :name, :match_count, :won_count, :draw_count, :lost_count, :goals, :goals_against,
                            :goals_difference, :points)

  helper EventsHelper
  load_and_authorize_resource

  before_action :set_event, only: [:show, :edit, :update, :destroy, :join, :leave, :schedule, :ranking, :team_join]


  # GET /events
  def index
    if get_shown_events_value == "on"
      @events = Event.all
    else
      @events = Event.active
    end
  end

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    if event_type
      @event = event_type.new
    else
      render :create_from_type
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = event_type.new(event_params)
    set_associations

    if @event.save
      @event.editors << current_user
      redirect_to @event, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  # PUT /events/1/join
  def join
    if @event.single?
      @event.add_participant(current_user)
    else
      @event.add_team(Team.find(event_params[:teams]))
    end
    flash[:success] = t('success.join_event', event: @event.name)
    redirect_back fallback_location: events_url
  end

  # GET /events/1/team_join
  def team_join
    respond_to do |format|
      format.js
    end
  end

  # PUT /events/1/leave
  def leave
    team = Team.find((current_user.owned_teams & @event.teams)[0].id)
    @event.remove_team(team)
    flash[:success] = t('success.leave_event', event: @event.name)
    redirect_back fallback_location: events_url
  end

  # GET /events/1/schedule
  def schedule
    if @event.matches.empty?
      @event.generate_schedule
      @event.save
    end
    @matches = @event.matches
    @schedule_type = @event.type.downcase!
  end

  # GET /events/1/ranking
  def ranking
    # Array of RankingEntry Structs that gets sorted when filled completely
    @ranking_entries = []

    # Leaves the Array of RankingEntry Structs empty when no teams participate in the event
    @event.teams.each do |team|
      ranking_entry = RankingEntry.new(nil, team.name, 0, 0, 0, 0, 0, 0, 0, 0)

      event_matches = @event.matches
      # Considers only the team's home matches that belong to the event
      home_matches_in_event = team.home_matches & event_matches
      parse_matches_data_into_ranking_entry team, ranking_entry, home_matches_in_event, :parse_match_details_for_home

      # Considers only the team's away matches that belong to the event
      away_matches_in_event = team.away_matches & event_matches
      parse_matches_data_into_ranking_entry team, ranking_entry, away_matches_in_event, :parse_match_details_for_away

      ranking_entry.goals_difference = ranking_entry.goals - ranking_entry.goals_against
      @ranking_entries.push ranking_entry
    end

    # Sorts the RankingEntries in the following order:
    #   1. DESCENDING by points
    #   2. DESCENDING by goals
    #   3. ASCENDING by name
    @ranking_entries = @ranking_entries.sort_by { | ranking_entry | [-ranking_entry.points, -ranking_entry.goals, ranking_entry.name] }

    # Adds a rank to each RankingEntry based on its position in the Array
    @ranking_entries.each_with_index do |ranking_entry, index|
      ranking_entry.rank = index + 1
    end
  end

  def parse_matches_data_into_ranking_entry(team, ranking_entry, matches, parse_match_details_for_home_or_away)
    matches.each do |match|
      # Validate data since matches do not always have both goals (scores) and points assigned
      score_home = match.score_home
      score_away = match.score_away
      points_home = match.points_home
      points_away = match.points_away
      match_has_result = score_home && score_away && points_home && points_away
      next unless match_has_result

      ranking_entry.match_count += 1
      parse_match_result_into_ranking_entry team, match, ranking_entry

      send(parse_match_details_for_home_or_away, ranking_entry, score_home, score_away, match)
    end
  end

  def parse_match_result_into_ranking_entry(team, match, ranking_entry)
    if match.has_winner?
      if match.winner == team
        ranking_entry.won_count += 1
      else
        ranking_entry.lost_count += 1
      end
    else
      ranking_entry.draw_count += 1
    end
  end

  def parse_match_details_for_home(ranking_entry, score_home, score_away, match)
    ranking_entry.goals += score_home
    ranking_entry.goals_against += score_away
    ranking_entry.points += match.points_home
  end

  def parse_match_details_for_away(ranking_entry, score_home, score_away, match)
    ranking_entry.goals += score_away
    ranking_entry.goals_against += score_home
    ranking_entry.points += match.points_away
  end

  def overview
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def set_associations
      @event.owner = current_user
      @event.player_type ||= Event.player_types[:single]
    end

    # Get the type of event that should be created
    def event_type
      return League if params[:type] == 'League'
      return Tournament if params[:type] == 'Tournament'
      return Rankinglist if params[:type] == 'Rankinglist'
      params[:type]
    end

    def get_shown_events_value
      params[:showAll]
    end

    def map_event_on_event_types
      [:league, :tournament, :rankinglist].each do |value|
        delete_mapping_parameter value
      end
    end

    def delete_mapping_parameter(event_class)
      if params.has_key? event_class
        params[:event] = params.delete event_class
      end
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      map_event_on_event_types
      params.require(:event).permit(:name,
                                    :description,
                                    :discipline,
                                    :type,
                                    :game_mode,
                                    :max_teams,
                                    :player_type,
                                    :deadline,
                                    :startdate,
                                    :teams,
                                    :enddate,
                                    :initial_value,
                                    :gameday_duration,
                                    :has_place_3_match,
                                    user_ids: [])
    end
end

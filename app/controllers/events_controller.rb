class EventsController < ApplicationController
  load_and_authorize_resource
  before_action :set_event, only: [:show, :edit, :update, :destroy, :join, :leave, :schedule, :team_join]

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
    case params[:type]
    when 'league'
      @event = League.new
    when 'tournament'
      @event = Tournament.new
    end
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    if params[:type] == 'league'
      @event = League.new event_params
    elsif params[:type] == 'tournament'
      @event = Tournament.new event_params
    end

    @event.owner = current_user

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
    if @event.single_player?
      @event.add_participant(current_user)
    else
      team = Team.find(event_params[:teams])
      @event.add_team(team)
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
    if @event.single_player?
      @event.remove_participant(current_user)
    else
      team = Team.find((current_user.owned_teams & @event.teams)[0].id)
      @event.remove_team(team)
    end
    flash[:success] = t('success.leave_event', event: @event.name)
    redirect_back fallback_location: events_url
  end

  def create_from_type
  end

  # GET /events/1/schedule
  def schedule
    if @event.teams.empty?
      @event.add_test_teams
      @event.generate_schedule
    end
    @matches = @event.matches.order('gameday ASC')
  end

  def overview
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
    end

    def get_shown_events_value
      params[:showAll]
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
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
                                    user_ids: [])
    end
end

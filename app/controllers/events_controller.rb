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
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)
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
    @event.add_participant(current_user)
    flash[:success] = t('success.join_event', event: @event.name)
    redirect_back fallback_location: events_url
  end

  # GET /events/1/team_join
  def team_join
    respond_to do |format|
      format.html
      format.js
    end
  end

  # PUT /events/1/leave
  def leave
    @event.remove_participant(current_user)
    flash[:success] = t('success.leave_event', event: @event.name)
    redirect_back fallback_location: events_url
  end

  # GET /events/1/schedule
  def schedule
    if @event.teams.empty?
      @event.add_test_teams
      @event.generate_schedule
    end
    @matches = @event.matches.order('gameday ASC')
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
      if params.has_key? :league
        params[:event] = params.delete :league
      elsif params.has_key? :tournament
        params[:event] = params.delete :tournament
      end

      params.require(:event).permit(:name,
                                    :description,
                                    :discipline,
                                    :type,
                                    :game_mode,
                                    :max_teams,
                                    :player_type,
                                    :deadline,
                                    :startdate,
                                    :enddate,
                                    user_ids: [])
    end
end

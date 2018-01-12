class EventsController < ApplicationController
  helper EventsHelper
  load_and_authorize_resource
  before_action :set_event, only: [:show, :edit, :update, :destroy, :join, :leave, :schedule]

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
    @event.add_participant(current_user)
    flash[:success] = t('success.join_event', event: @event.name)
    redirect_back fallback_location: events_url
  end

  # PUT /events/1/leave
  def leave
    @event.remove_participant(current_user)
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
                                    :enddate,
                                    :initial_value,
                                    :gameday_duration,
                                    user_ids: [])
    end
end

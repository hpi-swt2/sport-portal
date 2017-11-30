class EventsController < ApplicationController
  before_action :set_event, :set_user, only: [:show, :edit, :update, :destroy, :join]

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


  # PATCH/PUT /events/1/join
  def join
    @event.users << current_user
    if @event.save
      flash[:success] = "You have successfully joined #{@event.name}!"
      redirect_to @event
    else
      flash[:error] = "There was an error."
      render 'show'
    end
  end

  # GET /events/1/schedule
  def schedule
    @event = Event.find(params[:id])
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

    def set_user
      @user = current_user
    end

    # Only allow a trusted parameter "white list" through.
    def event_params
      params.require(:event).permit(:name,
                                    :description,
                                    :discipline,
                                    :game_mode,
                                    :max_teams,
                                    :player_type,
                                    :deadline,
                                    :startdate,
                                    :enddate,
                                    user_ids: [])
    end
end

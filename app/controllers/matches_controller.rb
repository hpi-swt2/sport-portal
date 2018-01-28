class MatchesController < ApplicationController
  before_action :set_match, only: [:show, :edit, :update, :update_points, :update_appointment, :destroy]

  # GET /matches/1
  def show
  end

  # GET /matches/new
  def new
    @match = Match.new
  end

  # GET /matches/1/edit
  def edit
  end

  # POST /matches
  def create
    @match = Match.new(match_params)

    if @match.save
      redirect_to @match, notice: I18n.t('helpers.flash.created', resource_name: Match.model_name.human).capitalize
    else
      render :new
    end
  end

  # PATCH/PUT /matches/1
  def update
    if @match.update(match_params)
      redirect_to @match, notice: I18n.t('helpers.flash.updated', resource_name: Match.model_name.human).capitalize
    else
      render :edit
    end
  end

  # PATCH/PUT /matches/1
  def update_points
    path = event_schedule_path(@match.event)
    if @match.update(match_points_params)
      redirect_to path, notice: t('success.updated_match_points')
    else
      redirect_to path, notice: t('error.update_match_points')
    end
  end

  def update_appointment
    path = event_schedule_path(@match.event)
    if @match.update(match_appointment_params)
      redirect_to path, notice: t('success.updated_appointment')
    else
      redirect_to path, notice: t('error.update_appointment')
    end
  end

  # DELETE /matches/1
  def destroy
    @match.destroy
    redirect_to event_schedule_path(@match.event), notice: I18n.t('helpers.flash.destroyed', resource_name: Match.model_name.human).capitalize
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_match
      @match = Match.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def match_params
      params.require(:match).permit(:place, :team_home_id, :team_away_id, :score_home, :score_away, :event_id, :start_time)
        .merge(team_home_type: 'Team', team_away_type: 'Team')
    end

    def match_points_params
      params.require(:match).permit(:points_home, :points_away)
    end

    def match_appointment_params
      params.require(:match).permit(:start_time, :place)
    end
end

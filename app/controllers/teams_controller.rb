class TeamsController < ApplicationController
  
  
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  # TODO: Consider using before_action
  # before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy, :assign_ownership_to, :assign_membership_to]

  # GET /teams
  def index
    @teams = Team.all
  end

  # GET /teams/1
  def show
  end

  # GET /teams/new
  def new
    @team = Team.new
  end

  # GET /teams/1/edit
  def edit
  end

  # POST /teams
  def create
    @team = Team.new(team_params)

    if user_signed_in?
      @team.owners << current_user
      @team.members << current_user
    end

    if @team.save
      redirect_to @team, notice: I18n.t('helpers.flash.created', resource_name: Team.model_name.human).capitalize
    else
      # TODO: Delete team ownership/membership created earlier, when saving the team failed
      render :new
    end
  end

  # PATCH/PUT /teams/1
  def update
    if @team.update(team_params)
      redirect_to @team, notice: I18n.t('helpers.flash.updated', resource_name: Team.model_name.human).capitalize
    else
      render :edit
    end
  end

  # DELETE /teams/1
  def destroy
    @team.destroy
    redirect_to teams_url, notice: I18n.t('helpers.flash.destroyed', resource_name: Team.model_name.human).capitalize
  end

  # Assigns team ownership to a specific team member
  def assign_ownership
    team_member_id = params[:team_member]
    @team = Team.find(params[:id])
    authorize! :assign_ownership, @team    


    # Checks whether the specified team member already has team ownership
    if @team.owners.exists?(team_member_id)
      return
    end

    @team.owners << User.find(team_member_id)
  end

  # Assigns team membership to a specific user
  def assign_membership

    # TODO: Consider check whether the current signed in user has team ownership

    # Checks whether the specified user already has team membership
    # TODO: Consider using a separate middleware for team membership
    if @team.members.exists?(user.id)
      return
    end

    @team.members << user
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name)
    end
end

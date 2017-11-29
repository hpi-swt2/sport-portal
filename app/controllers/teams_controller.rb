class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :assign_ownership, :delete_membership, :delete_ownership]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :team

  # GET /teams
  def index
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

    if @team.save
      # Assign team ownership and team membership to current signed in user who created the team
      assign_user_as_owner_and_member

      redirect_to @team, notice: I18n.t('helpers.flash.created', resource_name: Team.model_name.human).capitalize
    else
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
    # Delete all team ownerships and team memberships associated with the team to destroy
    team_id = @team.id
    TeamOwner.where(team_id: team_id).delete_all
    TeamMember.where(team_id: team_id).delete_all
    @team.destroy
    redirect_to teams_url, notice: I18n.t('helpers.flash.destroyed', resource_name: Team.model_name.human).capitalize
  end

  # Assigns team ownership to a specific team member
  def assign_ownership
    unless @team.owners.include? (User.find(params[:team_member]))
      @team.owners << User.find(params[:team_member])
      redirect_to @team
    end
  end

  def delete_ownership
    user = User.find(params[:team_member])

    if @team.owners.include?(user)
      @team.owners.delete(user)
      redirect_to @team
    end
  end

  def delete_membership
    user = User.find(params[:team_member])

    if @team.owners.include? (user)
      @team.owners.delete(user)
    end

    @team.members.delete(user)
    redirect_to @team
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params[:team_member])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :private, :description, :kind_of_sport, :owners, :members)
    end

    def assign_user_as_owner_and_member (user = current_user)
      @team.owners << user
      @team.members << user
    end
end

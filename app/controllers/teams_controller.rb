class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  before_action :set_team, only: [:show, :edit, :update, :destroy, :assign_ownership, :delete_membership, :delete_ownership]
  # before_action :set_user, only: [:assign_ownership, :delete_membership, :delete_ownership]
  before_action :owners_include_user, only: [:assign_ownership, :delete_membership, :delete_ownership]
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
      @team.owners << current_user

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
    TeamUser.where(team_id: team_id).delete_all
    @team.destroy

    redirect_to teams_url, notice: I18n.t('helpers.flash.destroyed', resource_name: Team.model_name.human).capitalize
  end

  # Assigns team ownership to a specific team member
  def assign_ownership
    unless owners_include_user
      team_owners << user
      redirect_to @team
    end
  end

  def delete_ownership
    delete_owner_if_existing
    redirect_to @team
  end

  def delete_membership
    delete_owner_if_existing
    @team.members.delete(user)
    redirect_to @team
  end

  def assign_membership_by_email
    user = User.find_by_email params[:email]
    if user
      assign_membership_to_user user
    else
      flash[:error] = 'No user for specified mail!'
    end
    redirect_to @team
  end

  def current_ability
    @current_ability ||= Ability.new(current_user, params[:team_member])
  end

  private
    def assign_membership_to_user (new_member)
      puts new_member.first_name
      unless @team.members.include? new_member
        @team.members << new_member
        # todo: send mail
        flash[:success] = 'Assigned membership!'
      else
        flash[:error] = 'User already member of team!'
      end
    end

    def delete_owner_if_existing
      if owners_include_user
        team_owners.delete user
      end
    end

    def team_owners
      @team_owners ||= @team.owners
    end

    def user
      @user ||= User.find(params[:team_member])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # def user
    #   @user = User.find(params[:team_member])
    # end

    def owners_include_user
      @user_in_owners ||= team_owners.include? user
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      # fixme: :email necessary here?
      params.require(:team).permit(:name, :private, :description, :kind_of_sport, :owners, :members, :email)
    end
end

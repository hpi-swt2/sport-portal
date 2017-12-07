class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :assign_ownership, :delete_membership, :delete_ownership, :perform_action_on_multiple_members]
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
    assign_ownership_to_member
    redirect_to @team
  end

  def delete_ownership
    delete_ownership_from_member
    redirect_to @team
  end

  def delete_membership
    delete_membership_from_member
    redirect_to @team
  end

  def perform_action_on_multiple_members
    # choose action based on submit button that was pressed
    if params[:assign_ownership]
      @action = "assign_ownership_to_member"
    elsif params[:delete_ownership]
      @action = "delete_ownership_from_member"
    elsif params[:delete_membership]
      @action = "delete_membership_from_member"  
    end

    params[:members].each do |member|
      params[:team_member] = member          
      begin
        send(@action)   
      rescue => ex
        print ex.message
      end
    end
    redirect_to @team
  end

  private
    def assign_ownership_to_member
      authorize! :assign_ownership, @team      
      @member_to_become_owner = TeamUser.find_by(user_id: user, team_id: @team.id)
      unless @member_to_become_owner.nil?
        @member_to_become_owner.update_attribute(:is_owner, true)
      end
    end

    def delete_ownership_from_member
      authorize! :delete_ownership, @team  
      @member_to_become_owner = TeamUser.find_by(user_id: user, team_id: @team.id)
      unless @member_to_become_owner.nil?
        @member_to_become_owner.update_attribute(:is_owner, false)
      end
    end

    def delete_membership_from_member
      authorize! :delete_membership, @team, user.id
      @team.members.delete(user)
    end

    def team_owners
      @team_owners ||= @team.owners
    end

    def user
      @user = User.find(params[:team_member])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :private, :description, :kind_of_sport, :owners, :members)
    end


end

class TeamsController < ApplicationController
  before_action :set_team, only: [:show, :edit, :update, :destroy, :assign_ownership, :delete_membership, :delete_ownership, :perform_action_on_multiple_members, :assign_membership_by_email]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]
  load_and_authorize_resource :team, only: [:index, :show, :new, :edit, :create, :update, :destroy]

  # GET /teams
  def index
    multi_teams = Team.multiplayer
    @teams = @teams & multi_teams
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
    assign_ownership_to_member params[:team_member]
    redirect_to @team
  end

  def delete_ownership
    delete_ownership_from_member params[:team_member]
    redirect_to @team
  end

  def delete_membership
    delete_membership_from_member params[:team_member]
    redirect_to @team
  end

  def perform_action_on_multiple_members
    target_members = ensure_current_user_is_last params[:members]
    unaffected_users = []
    target_members.each do |member_id|
      @team.reload
      begin
        if params[:assign_ownership]
          assign_ownership_to_member member_id
        elsif params[:delete_ownership]
          delete_ownership_from_member member_id
        elsif params[:delete_membership]
          delete_membership_from_member member_id
        end
      rescue => error
        unaffected_users << member_id
      end
    end
    inform_about_unaffected_users unaffected_users
    redirect_to @team
  end

  def assign_membership_by_email
    user = User.find_by_email params[:email]
    if user
      assign_membership_to_user user
    else
      flash[:error] = I18n.t('teams.invite_user_to_team.no_user_for_mail')
    end
    redirect_to @team
  end

  private
    def ensure_current_user_is_last (target_members)
      current_user_id_string = current_user.id.to_s
      if target_members.include? current_user_id_string
        target_members = (target_members - [current_user_id_string]) + [current_user_id_string]
      end
      target_members
    end

    def inform_about_unaffected_users (unaffected_users)
      unaffected_users_names = unaffected_users.map { |user| User.find(user).first_name }
      if unaffected_users_names.empty?
        flash[:success] = I18n.t('helpers.teams.multiple_actions.confirmation')
      else
        flash[:error] = I18n.t('helpers.teams.multiple_actions.failure_on', user_names: unaffected_users_names.join(", "))
      end
    end

    def assign_ownership_to_member(member_id)
      authorize! :assign_ownership, @team
      member_to_become_owner = TeamUser.find_by(user_id: member_id, team_id: @team.id)
      unless member_to_become_owner.nil?
        member_to_become_owner.assign_ownership
      end
    end

    def assign_membership_to_user (new_member)
      team_members = @team.members
      unless team_members.include? new_member
        team_members << new_member
        # todo: send mail
        flash[:success] = I18n.t('teams.invite_user_to_team.assignment_successful')
      else
        flash[:error] = I18n.t('teams.invite_user_to_team.user_already_in_team')
      end
    end

    def delete_ownership_from_member(member_id)
      authorize! :delete_ownership, Team.find(params[:id])
      member_to_become_owner = TeamUser.find_by(user_id: member_id, team_id: @team.id)
      unless member_to_become_owner.nil?
        member_to_become_owner.delete_ownership
      end
    end

    def delete_membership_from_member(member_id)
      authorize! :delete_membership, @team, member_id
      member = User.find(member_id)
      @team.members.delete(member)
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_team
      @team = Team.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def team_params
      params.require(:team).permit(:name, :private, :description, :kind_of_sport, :owners, :members, :avatar, :remove_avatar)
    end
end

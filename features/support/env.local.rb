module DataHelper
  def init_data_helper
    @matches = []
    @teams = []
    @users = []
    @named = {}
    @current_user = nil
  end

  def add_named_object(name, object)
    raise StandardError, "An object named '#{name}' already exists." if @named[name]
    @named[name] = object
  end

  def get_named_object(name, klass = Object)
    raise StandardError, "No #{klass.name.downcase} named '#{name}' exists." unless @named[name]
    raise StandardError, "'#{name}' is not a #{klass.name.humanize}" unless @named[name].is_a?(klass)
    @named[name]
  end

  def create_team(options = {})
    @teams << FactoryBot.create(:team, options)
    @teams.last
  end

  def create_team_named(name, options = {})
    add_named_object name, create_team(options)
  end

  def team_named(name)
    get_named_object name, Team
  end

  def create_match(options = {})
    @matches << FactoryBot.create(:match, options)
    @matches.last
  end

  def create_match_named(name, options = {})
    add_named_object name, create_match(options)
  end

  def match_named(name)
    get_named_object name, Match
  end

  def create_user(options = {})
    @users << FactoryBot.create(:user, options)
    @users.last
  end

  def create_user_named(name, options = {})
    add_named_object name, create_user(options)
  end

  def user_named(name)
    get_named_object name, User
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button I18n.t('devise.registrations.sign_in')
    @current_user = user
  end

  def ensure_current_user!
    raise 'No user is logged in!' unless @current_user
  end
end

World(DataHelper)

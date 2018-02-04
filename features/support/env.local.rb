require 'simplecov'

require 'capybara/email'

module DataHelper
  def init_data_helper
    @matches = []
    @teams = []
    @users = []
    @accounts = []
    @named = {}
    @events = []
    @tournaments = []
    @leagues = []
    @current_user = nil
  end

  def add_named_object(name, object)
    raise StandardError, "An object named '#{name}' already exists." if @named[name]
    @named[name] = object
  end

  def add_tournament(tournament)
    @tournaments << tournament
  end

  def get_named_object(name, klass = Object)
    raise StandardError, "No #{klass.name.downcase} named '#{name}' exists." unless @named[name]
    raise StandardError, "'#{name}' is not a #{klass.name.humanize}" unless @named[name].is_a?(klass)
    @named[name]
  end

  def get_single_object(collection)
    raise 'There is no such thing' if collection.count < 1
    raise 'Statement is ambiguous, there is more than one' if collection.count > 1
    collection.last
  end

  def create_user(options = {})
    @users << FactoryBot.create(:user, options)
    @users.last
  end

  def build_user(options = {})
    @users << FactoryBot.build(:user, options)
    @users.last
  end

  def create_user_named(name, options = {})
    add_named_object name, create_user(options)
  end

  def build_user_named(name, options = {})
    add_named_object name, build_user(options)
  end

  def user_named(name)
    get_named_object name, User
  end

  def single_user
    get_single_object(@users)
  end

  def create_event(options = {})
    @events << FactoryBot.create(:event, options)
    @events.last
  end

  def create_event_named(name, options = {})
    add_named_object name, create_event(options)
  end

  def event_named(name)
    get_named_object name, Event
  end

  def create_league(options = {})
    @leagues << FactoryBot.create(:league, options)
    @leagues.last
  end

  def build_league(options = {})
    @leagues << FactoryBot.build(:league, options)
    @leagues.last
  end

  def create_league_named(name, options = {})
    add_named_object name, create_league(options)
  end

  def build_league_named(name, options = {})
    add_named_object name, build_league(options)
  end

  def league_named(name)
    get_named_object name, League
  end

  def single_league
    get_single_object(@leagues)
  end

  def create_tournament(options = {})
    @tournaments << FactoryBot.create(:tournament, options)
    @tournaments.last
  end

  def build_tournament(options = {})
    @tournaments << FactoryBot.build(:tournament, options)
    @tournaments.last
  end

  def create_tournament_named(name, options = {})
    add_named_object name, create_tournament(options)
  end

  def tournament_named(name)
    get_named_object name, Tournament
  end

  def single_tournament
    get_single_object @tournaments
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

  def single_team
    get_single_object(@teams)
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

  def single_match
    get_single_object(@matches)
  end

  def create_omniauth_account(options = {})
    provider = options.delete(:provider)
    options[:uid] ||= '1234567890'
    user_options = FactoryBot.attributes_for(:user)
    options[:info] ||= {
      email: user_options[:email]
    }
    @accounts << OmniAuth.config.add_mock(provider, options)
    @accounts.last
  end

  def single_account
    get_single_object(@accounts)
  end

  def authenticate_with(account, provider = :hpiopenid)
    OmniAuth.config.mock_auth[provider] = account
  end

  def sign_in(user)
    visit new_user_session_path
    fill_in :user_email, with: user.email
    fill_in :user_password, with: user.password
    click_button I18n.t('devise.registrations.sign_in')
    @current_user = user
  end

  def sign_out
    page.driver.submit :delete, destroy_user_session_path, {}
    @current_user = nil
  end

  def ensure_current_user!
    raise 'No user is logged in!' unless @current_user
  end
end

World(DataHelper, Capybara::Email::DSL)

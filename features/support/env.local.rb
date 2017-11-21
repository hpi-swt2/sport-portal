
module DataHelper
  def init_data_helper
    @matches = []
    @teams = []
    @users = []
    @named = {}
  end

  def add_named_object(name, object)
    raise StandardError, "An object named '#{name}' already exists." if @named[name]
    @named[name] = object
  end

  def get_named_object(name, klass = Object)
    raise StandardError, "No #{klass.name.downcase} named '#{name}' exists." unless @named[name]
    raise StandardError, "'#{name}' is not a #{klass.name.downcase}" unless @named[name].is_a?(klass)
    @named[name]
  end

  def create_team(options = {})
    @teams << FactoryBot.create(:team, options)
    @teams.last
  end

  def create_team_named(name, options = {})
    team = create_team options
    add_named_object name, team
  end

  def team_named(name)
    get_named_object name, Team
  end

  def create_match(options = {})
    @matches << FactoryBot.create(:match, options)
    @matches.last
  end

  def create_match_named(name, options = {})
    match = create_match options
    add_named_object name, match
  end

  def match_named(name)
    get_named_object name, Match
  end
end

World(DataHelper)

class League < Event
  enum game_modes: [:round_robin, :two_halfs, :swiss, :danish]

  def add_test_teams
    max_teams.times do |index|
      teams << FactoryBot.create(:team)
    end
  end

  def generate_schedule
    calculate_gamedays
  end

  def gamedays
    size = teams.length
    size.even? ? size - 1 : size
  end

  def calculate_gamedays
    teams1 = teams.to_a
    teams2 = teams1.reverse
    team_len = teams.length
    gamedays.times do |gameday|
      matched_teams = []
      (team_len).times do |teamindex|
        team_1 = teams1[teamindex]
        team_2 = teams2[(gameday + teamindex) % team_len]
        unless (team_1 == team_2) || matched_teams.include?(team_1) || matched_teams.include?(team_2)
          matches << Match.new(team_home: team_1, team_away: team_2, gameday: gameday)
        end
        matched_teams << team_1
        matched_teams << team_2
      end
    end
    self.save
  end
end

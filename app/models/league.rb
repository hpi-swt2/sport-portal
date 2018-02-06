# == Schema Information
#
# Table name: events
#
#  id                   :integer          not null, primary key
#  name                 :string
#  description          :text
#  discipline           :string
#  player_type          :integer          not null
#  max_teams            :integer
#  game_mode            :integer          not null
#  type                 :string
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  startdate            :date
#  enddate              :date
#  deadline             :date
#  gameday_duration     :integer
#  owner_id             :integer
#  initial_value        :float
#  selection_type       :integer          default("fcfs"), not null
#  min_players_per_team :integer
#  max_players_per_team :integer
#  matchtype            :integer
#  bestof_length        :integer          default(1)
#  game_winrule         :integer
#  points_for_win       :integer          default(3)
#  points_for_draw      :integer          default(1)
#  points_for_lose      :integer          default(0)
#  image_data           :text
#

class League < Event
  validates :deadline, :startdate, :enddate, :selection_type, presence: true
  validates :gameday_duration, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1000 }
  validate :end_after_start, :start_after_deadline

  enum game_mode: [:round_robin, :two_halfs, :swiss]

  def generate_schedule
    if self.round_robin?
      calculate_round_robin
    elsif self.two_halfs?
      calculate_two_halfs
    elsif self.swiss?
      calculate_swiss_system_start
    end
  end

  def is_up_to_date
    return true unless self.swiss?
    return true if triangular(teams.length) == all_matches.length

    gamedays.last.endtime > DateTime.current
  end

  def update_schedule
    if self.swiss?
      calculate_swiss_system_new_gameday
    end
  end

  def have_already_played(team1, team2)
    pairings = matches.map { |match| Set[match.team_home, match.team_away] }
    pairings.include? Set[team1, team2]
  end

  def startdate_for_gameday(gameday_number)
    ((gameday_number - 1) * gameday_duration).days.since startdate
  end

  def enddate_for_gameday(gameday_number)
    startdate_for_gameday(gameday_number.next) - 1.day
  end

  def all_matches
    gamedays.map(&:matches).flatten
  end

  def invalidate_schedule
    super
    gamedays.delete_all
  end

  private

    def triangular(n)
      n * (n - 1) / 2
    end

    def calculate_round_robin
      pairings_per_day = round_robin_pairings teams.to_a
      pairings_per_day.each_with_index do |day, gameday_number|
        add_gameday
        day.each do |pairing|
          # Creating a match for every pairing if one of the teams is nil (which happens if there is an odd number of teams)
          # the other team will have to wait for this day
          add_match pairing[0], pairing[1], gameday_number
        end
      end
      save
    end

    def calculate_two_halfs
      pairings_per_day = round_robin_pairings teams.to_a
      pairings_per_day += round_robin_pairings teams.to_a
      pairings_per_day.each_with_index do |day, gameday_number|
        gameday = add_gameday
        day.each do |pairing|
          # Creating a match for every pairing if one of the teams is nil (which happens if there is an odd number of teams)
          # the other team will have to wait for this day
          match = add_match pairing[0], pairing[1], gameday_number
          if gameday_number >= teams.size
            switch_team_home_away match
          end
        end
      end
      save
    end

    # creates a twodimensional array of round robin pairings (one array per gameday) the inner array consists of the pairings
    def round_robin_pairings(teams_array)
      teams_array.push nil if teams_array.size.odd?
      n = teams_array.size
      pivot = teams_array.pop

      games = (n - 1).times.map do
        teams_array.rotate!
        [[teams_array.first, pivot]] + (1...(n / 2)).map { |j| [teams_array[j], teams_array[n - 1 - j]] }
      end

      # remove all matches that include a nil object
      games.map { |game| game.select { |match| !match[1].nil? } }
    end

    def penalty(ranked_teams, matches)
      return Float::INFINITY if matches.flatten.uniq.length != matches.flatten.length
      matches.inject(0) { |sum, match| sum + penalty_for_match(ranked_teams, match) }
    end

    def penalty_for_match(ranked_teams, match)
      return Float::INFINITY if have_already_played(match[0], match[1])
      (ranked_teams.index(match[0]) - ranked_teams.index(match[1])).abs
    end

    def calculate_swiss_system_new_gameday
      add_gameday
      gameday_number = gamedays.length - 1
      ranking = get_ranking
      ranked_teams = ranking.map(&:team)

      all_matches = ranked_teams.to_a.combination(2).to_a.combination((ranked_teams.length / 2).floor)
      best_matches = all_matches.min_by do |matches|
        penalty(ranked_teams, matches)
      end
      best_matches.each do |match|
        add_match(match[0], match[1], gameday_number)
      end
    end

    # create a random first gameday for the swiss system
    def calculate_swiss_system_start
      add_gameday
      shuffled_teams = teams.to_a.shuffle
      middle_index = (teams.length / 2).floor
      shuffled_teams.first(middle_index).each_with_index do |team, index|
        team_away = shuffled_teams[middle_index + index]
        add_match(team, team_away, 0)
      end
    end

    def add_match(team_home, team_away, gameday_number)
      match = Match.new(team_home: team_home, team_away: team_away, gameday_number: gameday_number + 1, start_time: gamedays[gameday_number].starttime)
      gamedays[gameday_number].matches << match
      matches << match # deprecated but still used for gameday calculation, refactoring to be continued
      match
    end

    def add_gameday
      next_gameday_index = gamedays.length
      gamedays << Gameday.new(description: next_gameday_index.to_s,
                              starttime: startdate_for_gameday(next_gameday_index),
                              endtime: enddate_for_gameday(next_gameday_index))
      gamedays.last
    end

    def switch_team_home_away(match)
      home = match.team_home
      match.team_home = match.team_away
      match.team_away = home
      match
    end
end

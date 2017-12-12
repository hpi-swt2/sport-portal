# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string
#  description      :text
#  discipline       :string
#  player_type      :integer          not null
#  max_teams        :integer
#  game_mode        :integer          not null
#  type             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  startdate        :date
#  enddate          :date
#  deadline         :date
#  gameday_duration :integer
#  owner_id         :integer
#

class Tournament < Event
  enum game_modes: [:ko, :ko_group, :double_elimination]

  def generate_schedule
    filled_teams = []
    teams.each { |team| filled_teams << team }
    filled_teams.shuffle!
    insert_index = 0
    until is_power_of_two? filled_teams.length
      filled_teams.insert(insert_index, nil)
      insert_index += 2
    end
    build_matches teams, max_match_level

    last_gameday = nil
    index = 1
    matches.each { |match|
      if match.gameday != last_gameday
        last_gameday = match.gameday
        index = 1
      end
      match.index = index
      match.save!
      index += 1
    }
  end

  def build_matches(team_array, depth)
    team_count = team_array.length
    if team_count <= 2
      if team_array[0] == nil
        return team_array[1]
      elsif team_array[1] == nil
        return team_array[0]
      end
      return create_match team_array[0], team_array[1], depth
    end

    half_team_count = team_count / 2
    left_half = team_array[0 .. (half_team_count - 1)]
    right_half = team_array[half_team_count .. (team_count - 1)]
    match1 = build_matches(left_half, depth - 1)
    match2 = build_matches(right_half, depth - 1)

    create_match match1, match2, depth
  end

  def is_power_of_two?(number)
    number.to_s(2).count('1') == 1
  end

  def create_match(team1, team2, depth)
    match = Match.new(team_home: team1, team_away: team2, gameday: depth, event: self)
    match.save!
    match
  end

  def max_match_level
    (Math.log teams.length, 2).ceil - 1
  end
end

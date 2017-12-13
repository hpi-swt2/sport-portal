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

  def standing_of(team)
    get_standing_of team, finale
  end

  def finale
    finale = nil
    matches.each do |match|
      if match.depth == 0
        finale = match
      end
    end
    #TODO: keep care of 3rd place match here
    finale
  end

  def generate_schedule
    build_matches filled_teams, max_match_level
    set_match_indices
  end

  def max_match_level
    (Math.log teams.length, 2).ceil - 1
  end

  private

    def get_standing_of(team, match)
      if match.is_team_recursive? team
        return standing_of_string team, match
      end
      standing_of_recursion_step(team, match.team_home) || standing_of_recursion_step(team, match.team_away)
    end

    def standing_of_string(team, match)
      match_name = match.round
      if match.loser == team
        return I18n.t 'events.overview.out', match_name: match_name
      end
      I18n.t 'events.overview.in', match_name: match_name
    end

    def standing_of_recursion_step(team, child)
      if child.is_a? Match
        get_standing_of team, child
      end
    end

    def filled_teams
      filled_teams = shuffled_teams
      insert_index = 0
      until is_power_of_two? filled_teams.length
        filled_teams.insert(insert_index, nil)
        insert_index += 2
      end
      filled_teams
    end

    def shuffled_teams
      team_copy = []
      teams.each { |team| team_copy << team }
      team_copy.shuffle!
    end

    def build_matches(team_array, depth)
      team_count = team_array.length
      if team_count <= 2
        return build_leaf_match *team_array, depth
      end

      left_half, right_half = split_teams_array team_array
      child_depth = depth - 1
      match_left = build_matches(left_half, child_depth)
      match_right = build_matches(right_half, child_depth)

      create_match match_left, match_right, depth
    end

    def split_teams_array(team_array)
      team_count = team_array.length
      half_team_count = team_count / 2
      left_half = team_array[0 .. (half_team_count - 1)]
      right_half = team_array[half_team_count .. (team_count - 1)]
      return left_half, right_half
    end

    def build_leaf_match(team_home, team_away, depth)
      unless team_home.nil? || team_away.nil?
        return create_match team_home, team_away, depth
      end
      team_home || team_away
    end

    def create_match(team_home, team_away, depth)
      match = Match.new(team_home: team_home, team_away: team_away, gameday: depth, event: self)
      match.save!
      match
    end

    def set_match_indices
      last_gameday = nil
      index = 1
      matches.each do |match|
        new_gameday = match.gameday
        if new_gameday != last_gameday
          last_gameday = new_gameday
          index = 1
        end
        match.index = index
        match.save!
        index += 1
      end
    end

    def is_power_of_two?(number)
      number.to_s(2).count('1') == 1
    end
end

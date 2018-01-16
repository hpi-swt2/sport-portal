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
  validates :deadline, :startdate, :enddate, presence: true
  validate :end_after_start, :start_after_deadline

  enum game_mode: [:ko, :ko_group, :double_elimination]

  def standing_of(team)
    final_match = finale
    return super(team) if final_match.blank?

    special_standing = special_standing_of team
    return special_standing if special_standing.present?

    final_match.last_match_of(team).standing_string_of team
  end

  def finale
    matches.each do |match|
      if match.depth == 0
        return match
      end
    end
    nil
  end

  def place_3_match
    matches.each do |match|
      if match.depth == -1
        return match
      end
    end
    nil
  end

  def generate_schedule
    team_count = teams.size
    return if team_count < 2
    create_matches filled_teams, max_match_level, 0
    normalize_first_layer_match_indices
    if team_count >= 4
      create_place_3_match
    end
  end

  def max_match_level
    Math.log(teams.length, 2).ceil - 1
  end

  private

    def special_standing_of(team)
      final_match = finale
      if final_match.winner == team
        I18n.t 'events.placing.first'
      elsif final_match.loser == team
        I18n.t 'events.placing.second'
      else
        place_3_standing_of team
      end
    end

    def place_3_standing_of(team)
      p3m = place_3_match
      if p3m.present?
        if p3m.winner == team
          I18n.t 'events.placing.third'
        elsif p3m.loser == team
          I18n.t 'events.placing.fourth'
        elsif p3m.is_team_recursive?(team)
          I18n.t 'events.overview.in_place_3_match'
        end
      end
    end

    def filled_teams
      # converts 12345
      # to       x1x2x345
      # (where x == nil)
      # in order to deal with a number of teams that is not a power of two
      filled_teams = shuffled_teams
      insert_index = 0
      until Tournament.is_power_of_two? filled_teams.length
        filled_teams.insert insert_index, nil
        insert_index += 2
      end
      filled_teams
    end

    def shuffled_teams
      teams.to_a.shuffle!
    end

    def create_matches(team_array, depth, index)
      if team_array.length <= 2
        return create_leaf_match *team_array, depth, index
      end

      match_left, match_right = create_child_matches(team_array, depth, index)

      match = create_match match_left, match_right, depth, index
      Tournament.create_match_participant match, true
    end

    def create_child_matches(team_array, depth, index)
      left_half, right_half = Tournament.split_teams_array team_array
      child_depth = depth - 1
      child_index = index * 2
      match_left = create_matches left_half, child_depth, child_index
      match_right = create_matches right_half, child_depth, child_index + 1
      [match_left, match_right]
    end

    def create_leaf_match(team_home, team_away, depth, index)
      if team_home.present? && team_away.present?
        match = create_match team_home, team_away, depth, index
        return Tournament.create_match_participant match, true
      end
      team_home || team_away
    end

    def create_match(team_home, team_away, depth, index)
      match = Match.new team_home: team_home, team_away: team_away, gameday: depth, index: index + 1, event: self
      matches << match
      match.save!
      match
    end

    def normalize_first_layer_match_indices
      matches.each do |match|
        if match.gameday == 0
          match.adjust_index_by first_gameday_offset
        end
      end
    end

    def first_gameday_offset
      teams_size = teams.size
      return 0 if Tournament.is_power_of_two? teams_size
      2**teams_size.to_s(2).length - teams_size
    end

    def create_place_3_match
      loser_home, loser_away = place_3_match_participants
      match = Match.new team_home: loser_home, team_away: loser_away, gameday: max_match_level + 1, index: 1, event: self
      matches << match
      match.save!
    end

    def place_3_match_participants
      final_match = finale
      loser_home = Tournament.create_match_participant final_match.team_home.match, false
      loser_away = Tournament.create_match_participant final_match.team_away.match, false
      [loser_home, loser_away]
    end

    class << self
      def split_teams_array(team_array)
        half_team_count = team_array.length / 2
        left_half = team_array.first half_team_count
        right_half = team_array.last half_team_count
        return left_half, right_half
      end

      def is_power_of_two?(number)
        number.to_s(2).count('1') == 1
      end

      def create_match_participant(match, winner)
        match_result = MatchResult.new match: match, winner_advances: winner
        match_result.save!
        match_result
      end
    end
end

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
    last_match = finale.last_match_of team
    last_match.standing_string_of team
  end

  def finale
    #TODO: keep care of 3rd place match here
    matches.each do |match|
      if match.depth == 0
        return match
      end
    end
    nil
  end

  def generate_schedule
    create_matches filled_teams, max_match_level, 0
    normalize_first_layer_match_indices
  end

  def max_match_level
    Math.log(teams.length, 2).ceil - 1
  end

  private

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

      create_match match_left, match_right, depth, index
    end

    def create_child_matches(team_array, depth, index)
      left_half, right_half = Tournament.split_teams_array team_array
      child_depth = depth - 1
      child_index = index * 2
      match_left = create_matches left_half, child_depth, child_index
      match_right = create_matches right_half, child_depth, child_index + 1
      return match_left, match_right
    end

    def create_leaf_match(team_home, team_away, depth, index)
      if team_home.present? && team_away.present?
        return create_match team_home, team_away, depth, index
      end
      team_home || team_away
    end

    def create_match(team_home, team_away, depth, index)
      match = Match.new team_home: team_home, team_away: team_away, gameday: depth, index: index + 1, event: self
      match.save!
      match
    end

    def normalize_first_layer_match_indices
      first_match = matches[0]
      first_gameday_index_offset = first_match.index - 1
      matches.each do |match|
        if match.gameday == first_match.gameday
          match.adjust_index_by first_gameday_index_offset
        end
      end
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
    end
end

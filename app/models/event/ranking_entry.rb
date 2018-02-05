class Event
  # Smallest unit of a ranking. Contains different data for one team and contains logic to parse this data out of
  # match objects.
  class RankingEntry
    attr_reader :team, :match_count, :won_count, :draw_count, :lost_count, :goals, :goals_against, :goals_difference, :points
    attr_accessor :rank

    def initialize(team, home_matches, away_matches)
      @team = team
      @home_matches = home_matches
      @away_matches = away_matches

      @rank = 0
      @match_count = 0
      @won_count = 0
      @draw_count = 0
      @lost_count = 0
      @goals = 0
      @goals_against = 0
      @goals_difference = 0
      @points = 0
    end

    def calculate_ranking_entry
      parse_matches_data @home_matches, :parse_match_details_for_home
      parse_matches_data @away_matches, :parse_match_details_for_away
      @goals_difference = @goals - @goals_against
    end

    def parse_matches_data(matches, parse_match_details_for_home_or_away)
      matches.each do |match|
        next unless match.has_result?

        @match_count += 1
        parse_match_result match

        send(parse_match_details_for_home_or_away, match)
      end
    end

    def parse_match_result(match)
      if match.has_winner?
        if match.winner == @team
          @won_count += 1
        else
          @lost_count += 1
        end
      else
        @draw_count += 1
      end
    end

    def parse_match_details_for_home(match)
      @goals += match.score_home_total
      @goals_against += match.score_away_total
      @points += match.points_home
    end

    def parse_match_details_for_away(match)
      @goals += match.score_away_total
      @goals_against += match.score_home_total
      @points += match.points_away
    end
  end
end

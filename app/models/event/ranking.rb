class Event
  # Contains logic for calculating an array containing ranking entries out of an array of teams and matches.
  class Ranking
    def initialize(teams, matches)
      @teams = teams
      @matches = matches
      @ranking_entries = []
    end

    def get_ranking
      # Leaves the Array of RankingEntries empty when no teams participate in the event
      @teams.each do |team|
        # Considers only the team's away matches that belong to this ranking list
        home_matches_in_event = team.home_matches & @matches
        away_matches_in_event = team.away_matches & @matches
        ranking_entry = RankingEntry.new(team, home_matches_in_event, away_matches_in_event)
        ranking_entry.calculate_ranking_entry
        @ranking_entries.push ranking_entry
      end

      # Sorts the RankingEntries in the following order:
      #   1. DESCENDING by points
      #   2. DESCENDING by goals
      #   3. ASCENDING by name
      @ranking_entries = @ranking_entries.sort_by { | ranking_entry | [-ranking_entry.points, -ranking_entry.goals, ranking_entry.name] }

      # Adds a rank to each RankingEntry based on its position in the Array
      @ranking_entries.each_with_index do |ranking_entry, index|
        ranking_entry.rank = index + 1
      end
    end
  end
end

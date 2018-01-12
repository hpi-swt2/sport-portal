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

class League < Event
  validates :deadline, :startdate, :enddate, :selection_type, presence: true
  validates :gameday_duration, presence: true
  validate :end_after_start, :start_after_deadline

  enum game_mode: [:round_robin, :two_halfs, :swiss, :danish]

  def generate_schedule
    calculate_round_robin
  end

  def calculate_round_robin
    pairings_per_day = round_robin_pairings teams.to_a
    pairings_per_day.each_with_index do |day, gameday|
      day.each do |pairing|
        # Creating a match for every pairing if one of the teams is nil (which happens if there is an odd number of teams)
        # the other team will have to wait for this day
        matches << Match.new(team_home: pairing[0], team_away: pairing[1], gameday: gameday + 1) unless pairing[0].nil? || pairing[1].nil?
      end
    end
    save
  end

  # creates a twodimensional array of round robin pairings (one array per gameday) the inner array consists of the pairings
  def round_robin_pairings(teams_array)
    teams_array.push nil if teams_array.size.odd?
    n = teams_array.size
    pivot = teams_array.pop

    (n - 1).times.map do
      teams_array.rotate!
      [[teams_array.first, pivot]] + (1...(n / 2)).map { |j| [teams_array[j], teams_array[n - 1 - j]] }
    end
  end

  def startdate_for_gameday(gameday)
    ((gameday - 1) * gameday_duration).days.since startdate
  end

  def enddate_for_gameday(gameday)
    startdate_for_gameday(gameday.next) - 1.day
  end
end

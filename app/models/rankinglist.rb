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

class Rankinglist < Event
  validates :deadline, :startdate, :enddate, presence: false

  enum game_mode: [:elo]

  def update_rankings(match)
    if (elo?)
      match.apply_elo
    end
  end

  def can_leave?(user)
    has_participant? user
  end

  before_validation do
    self.player_type = Event.player_types[:single]
    self.min_players_per_team = 1
    self.max_players_per_team = 1
  end

  def self.template_events
    list = Array.new

    rankinglist = Rankinglist.new
    rankinglist.assign_attributes(
        name: 'Will be replaced with PO data',
        description: 'A very nice rankinglist.',
        discipline: 'Rankinglist Discipline',
        max_teams: 12,
        game_mode: Rankinglist.game_modes[:true_skill],
        type: 'Rankinglist',
        created_at: Date.yesterday,
        updated_at: Date.yesterday,
        owner_id: nil,
        image_data: File.open("#{Rails.root}/app/assets/images/missing_event_image.jpg"))
    list << rankinglist

    list
  end
end

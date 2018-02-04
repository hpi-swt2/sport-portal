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

    rankinglist1 = Rankinglist.new
    rankinglist1.assign_attributes(
        name: I18n.t('events.templates.rankinglist1.name'),
        description: '',
        discipline: I18n.t('events.templates.rankinglist1.discipline'),
        max_teams: 100,
        initial_value: 20,
        game_mode: Rankinglist.game_modes[:elo],
        type: 'Rankinglist',
        image: open('https://owncloud.hpi.de/index.php/s/hkq3TILn6b4zeXp/download'))
    list << rankinglist1

    rankinglist2 = Rankinglist.new
    rankinglist2.assign_attributes(
        name: I18n.t('events.templates.rankinglist2.name'),
        description: '',
        discipline: I18n.t('events.discipline.table_football'),
        initial_value: 20,
        game_mode: Rankinglist.game_modes[:elo],
        type: 'Rankinglist',
        image: open('https://owncloud.hpi.de/index.php/s/HPHEQZIDE6NjixX/download'))
    list << rankinglist2

    list

  end
end

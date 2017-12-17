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

  enum game_modes: [:ko, :ko_group, :double_elimination]

  def can_join?(user)
    single_player? && (not has_participant?(user)) && (not deadline_has_passed?)
  end
end

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
#  initial_value    :float
#  matchtype        :integer
#  bestof_length    :integer
#  game_winrule     :integer
#  points_for_win   :integer
#  points_for_draw  :integer
#  points_for_lose  :integer
#

class League < Event
  enum game_modes: [:round_robin, :two_halfs, :swiss, :danish]
end

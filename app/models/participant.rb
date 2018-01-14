# == Schema Information
#
# Table name: participants
#
# id                                      :integer          not null, primary key
# particable_type                         :string
# particable_id                           :integer
# created_at                              :datetime         not null
# updated_at                              :datetime         not null
# index_participants_on_particable_type_and_particable_id :index
#

class Participant < ApplicationRecord
  has_many :home_matches, as: :team_home, class_name: 'Match'
  has_many :away_matches, as: :team_away, class_name: 'Match'

  has_and_belongs_to_many :events

  def in_event?
    puts "como estas"
    events.exists?
  end

  # these methods allow participants to be treated like matches. see Match model
  def winner
    self
  end

  def matches
    home_matches.or away_matches
  end

  def last_match_of(_participant)
  end
end
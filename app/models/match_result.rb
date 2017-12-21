# == Schema Information
#
# Table name: match_results
#
#  id               :integer          not null, primary key
#  match            :integer          (points to a Match Object)
#  winner           :boolean
#

class MatchResult < ApplicationRecord
  has_one :match


end

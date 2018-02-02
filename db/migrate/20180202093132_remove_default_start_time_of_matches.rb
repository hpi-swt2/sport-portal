require_relative '20180124104518_add_default_start_time_to_matches.rb'

class RemoveDefaultStartTimeOfMatches < ActiveRecord::Migration[5.1]
  def change
    revert AddDefaultStartTimeToMatches
  end
end

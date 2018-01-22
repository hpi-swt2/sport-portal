class CopyStartdateToStarttime < ActiveRecord::Migration[5.1]
  def change
    Match.update_all(:start_time => (Event.select(:startdate).where(Match.select(:event_id)==Event.select(:id))).first[:startdate].to_datetime)
  end

end

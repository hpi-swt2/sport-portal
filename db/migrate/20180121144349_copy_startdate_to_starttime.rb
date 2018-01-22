class CopyStartdateToStarttime < ActiveRecord::Migration[5.1]
  def up
    Match.update_all(:start_time => (Event.select(:startdate).where(Match.select(:event_id)==Event.select(:id)))[0].startdate.to_s.to_datetime)
  end

  def down
  end
end

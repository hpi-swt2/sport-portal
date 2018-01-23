class CopyStartdateToStarttime < ActiveRecord::Migration[5.1]
  def change
    Event.find_each do | event |
      event.matches.update_all(start_time: event.startdate)
    end
  end

end

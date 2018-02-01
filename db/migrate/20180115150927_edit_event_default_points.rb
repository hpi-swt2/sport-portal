class EditEventDefaultPoints < ActiveRecord::Migration[5.1]
  def change
    change_column_default(:events, :points_for_win, from: nil, to: 3)
    change_column_default(:events, :points_for_draw, from: nil, to: 1)
    change_column_default(:events, :points_for_lose, from: nil, to: 0)
    change_column_default(:events, :bestof_length, from: nil, to: 1)
  end
end

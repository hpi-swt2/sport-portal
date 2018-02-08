class AddMaximumEloChangeToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :maximum_elo_change, :integer
  end
end

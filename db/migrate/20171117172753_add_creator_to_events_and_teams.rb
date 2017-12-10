class AddCreatorToEventsAndTeams < ActiveRecord::Migration[5.1]
  def change
    add_reference :teams, :creator, foreign_key: { to_table: :users }
    add_reference :events, :creator, foreign_key: { to_table: :users }
  end
end

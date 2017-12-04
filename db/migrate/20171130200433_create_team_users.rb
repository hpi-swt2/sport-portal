class CreateTeamUsers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :teams, :users, table_name: :team_users do |t|
      t.index [:user_id, :team_id]
      t.boolean :is_owner
    end
  end
end

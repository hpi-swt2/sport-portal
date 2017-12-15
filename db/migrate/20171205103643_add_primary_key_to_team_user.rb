class AddPrimaryKeyToTeamUser < ActiveRecord::Migration[5.1]
  def change
    add_column :team_users, :id, :primary_key
  end
end

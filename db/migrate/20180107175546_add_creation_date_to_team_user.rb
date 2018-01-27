class AddCreationDateToTeamUser < ActiveRecord::Migration[5.1]
  def change
    add_column :team_users, :created_at, :timestamp
  end
end

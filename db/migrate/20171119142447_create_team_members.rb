class CreateTeamMembers < ActiveRecord::Migration[5.1]
  def change
    create_join_table :teams, :users, table_name: :team_members do |t|

    end
  end
end

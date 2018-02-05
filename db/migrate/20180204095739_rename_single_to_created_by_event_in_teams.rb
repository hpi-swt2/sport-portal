class RenameSingleToCreatedByEventInTeams < ActiveRecord::Migration[5.1]
  def change
    rename_column :teams, :single, :created_by_event
  end
end

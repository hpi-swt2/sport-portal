class RemoveCreatorFromTeams < ActiveRecord::Migration[5.1]
  def change
    remove_reference :teams, :creator
  end
end

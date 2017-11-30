class RenameCreatorToOwnerInEvents < ActiveRecord::Migration[5.1]
  def change
    add_reference :events, :owner, foreign_key: { to_table: :users}
    Event.update_all("owner_id=creator_id")
    remove_reference :events, :creator
  end
end

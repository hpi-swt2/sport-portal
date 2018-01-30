class CreateParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.integer :event_id
      t.integer :team_id
      t.float :rating

      t.timestamps
    end
  end
end

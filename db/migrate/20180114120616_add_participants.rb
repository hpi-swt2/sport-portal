class AddParticipants < ActiveRecord::Migration[5.1]
  def change
    create_table :participants do |t|
      t.timestamps
      t.references :particable, polymorphic: true, index: true
    end

    create_join_table :events, :participants do |t|
      t.index [:event_id, :participant_id]
      t.index [:participant_id, :event_id]
    end
  end
end

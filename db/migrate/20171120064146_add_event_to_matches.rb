class AddEventToMatches < ActiveRecord::Migration[5.1]
  def change
    add_reference :matches, :event, foreign_key: true
  end
end

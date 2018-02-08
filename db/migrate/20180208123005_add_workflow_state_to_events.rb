class AddWorkflowStateToEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :workflow_state, :string
  end
end

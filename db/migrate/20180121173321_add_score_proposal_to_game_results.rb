class AddScoreProposalToGameResults < ActiveRecord::Migration[5.1]
  def change
    add_reference :game_results, :scores_proposed_by, foreign_key: { to_table: :users }
  end
end
class AddScoreProposalToGameResults < ActiveRecord::Migration[5.1]
  def change
    add_column :game_results, :proposed_score_home, :integer
    add_column :game_results, :proposed_score_away, :integer
    add_reference :game_results, :scores_proposed_by, foreign_key: { to_table: :users }
  end
end

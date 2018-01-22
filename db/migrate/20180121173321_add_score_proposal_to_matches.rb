class AddScoreProposalToMatches < ActiveRecord::Migration[5.1]
  def change
    add_column :matches, :proposed_score_home, :integer
    add_column :matches, :proposed_score_away, :integer
    add_reference :matches, :scores_proposed_by, foreign_key: { to_table: :users }
  end
end

class AddScoreProposalToMatches < ActiveRecord::Migration[5.1]
  def change
    add_reference :matches, :scores_proposed_by, foreign_key: { to_table: :teams }
  end
end

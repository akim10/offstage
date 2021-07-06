class AddVotesAndRoundToWinners < ActiveRecord::Migration[6.0]
  def change
    add_column :winners, :votes, :integer
    add_column :winners, :round, :integer
  end
end

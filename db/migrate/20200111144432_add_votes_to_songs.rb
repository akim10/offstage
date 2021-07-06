class AddVotesToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :votes, :integer, :default => 0
  end
end

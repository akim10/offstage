class RemoveSongsToVoteAndBracketArray < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :songs_to_vote
    remove_column :users, :bracket_array
  end
end

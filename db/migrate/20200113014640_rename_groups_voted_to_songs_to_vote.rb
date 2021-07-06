class RenameGroupsVotedToSongsToVote < ActiveRecord::Migration[6.0]
  def change
    rename_column :users, :groups_voted, :songs_to_vote
  end
end
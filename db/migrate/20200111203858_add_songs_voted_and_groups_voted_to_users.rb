class AddSongsVotedAndGroupsVotedToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :songs_voted, :integer, array: true, default: []
    add_column :users, :groups_voted, :integer, array: true, default: []
  end
end

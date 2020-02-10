class AddGroupIdToSong < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :group_id, :integer
  end
end

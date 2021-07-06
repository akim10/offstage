class RemoveLinkFromSongs < ActiveRecord::Migration[6.0]
  def change
    remove_column :songs, :link, :string
  end
end

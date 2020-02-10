class AddRoundToSongs < ActiveRecord::Migration[6.0]
  def change
    add_column :songs, :round, :integer, default: 1
  end
end

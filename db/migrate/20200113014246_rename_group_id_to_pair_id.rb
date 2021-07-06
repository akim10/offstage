class RenameGroupIdToPairId < ActiveRecord::Migration[6.0]
  def change
    rename_column :songs, :group_id, :pair_id
  end
end

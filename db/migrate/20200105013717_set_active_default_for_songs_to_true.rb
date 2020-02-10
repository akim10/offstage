class SetActiveDefaultForSongsToTrue < ActiveRecord::Migration[6.0]
  def change
    change_column :songs, :active, :boolean, default: true
  end
end

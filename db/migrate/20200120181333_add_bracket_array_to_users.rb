class AddBracketArrayToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :bracket_array, :integer, array: true, default: []
  end
end

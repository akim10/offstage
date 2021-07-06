class AddActiveToWinners < ActiveRecord::Migration[6.0]
  def change
    add_column :winners, :active, :boolean
  end
end

class CreateWinners < ActiveRecord::Migration[6.0]
  def change
    create_table :winners do |t|
      t.string :track_id
      t.string :artist_id
      t.integer :user_id

      t.timestamps
    end
  end
end

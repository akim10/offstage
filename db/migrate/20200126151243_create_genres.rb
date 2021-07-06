class CreateGenres < ActiveRecord::Migration[6.0]
  def change
    create_table :genres do |t|
      t.string :state, default: "not started"
      t.string :genre
      t.integer :participant_cap, default: 64
      t.integer :round, default: 1

      t.timestamps
    end
  end
end

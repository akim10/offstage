class CreateArtistProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :artist_profiles do |t|
      t.string :artist_name
      t.string :name
      t.text :bio
      t.string :city
      t.string :state
      t.boolean :active
      t.integer :user_id
      t.string :soundcloud
      t.string :spotify
      t.string :applemusic

      t.timestamps
    end
  end
end

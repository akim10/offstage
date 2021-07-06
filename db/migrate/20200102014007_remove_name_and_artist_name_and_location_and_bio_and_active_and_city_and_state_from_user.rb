class RemoveNameAndArtistNameAndLocationAndBioAndActiveAndCityAndStateFromUser < ActiveRecord::Migration[6.0]
  def change

    remove_column :users, :name, :string

    remove_column :users, :artist_name, :string

    remove_column :users, :location, :string

    remove_column :users, :bio, :string

    remove_column :users, :active, :boolean

    remove_column :users, :city, :string

    remove_column :users, :state, :string
  end
end

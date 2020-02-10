class AddSongQueueToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :song_queue, :json, :default => {"hiphop":[], "edm":[], "pop":[], "indie":[]}
    add_column :users, :bracket_order, :json, :default => {"hiphop":[], "edm":[], "pop":[], "indie":[]}
  end
end

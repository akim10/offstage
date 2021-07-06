class ChangePopToRockGenre < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :song_queue, {"hiphop"=>[*1..8], "edm"=>[*1..8], "rock"=>[*1..8], "indie"=>[*1..8]}
    change_column_default :users, :bracket_order, {"hiphop"=>[*1..8], "edm"=>[*1..8], "rock"=>[*1..8], "indie"=>[*1..8]}
  end
end

class ChangeGenreParticipantCapBackToThirtyTwo < ActiveRecord::Migration[6.0]
  def change
    change_column_default :users, :song_queue, {"hiphop"=>[*1..16], "edm"=>[*1..16], "rock"=>[*1..16], "indie"=>[*1..16]}
    change_column_default :users, :bracket_order, {"hiphop"=>[*1..16], "edm"=>[*1..16], "rock"=>[*1..16], "indie"=>[*1..16]}
  end
end

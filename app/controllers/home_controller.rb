class HomeController < ApplicationController
  def index
    if user_signed_in?
      if current_user.genre_id == nil
        redirect_to edit_user_path(current_user)
      else
        # round info
        @current_genre = current_user.genre
        @current_genre_name = @current_genre.format_genre
        @state = @current_genre.state
        @display_name = RSpotify::User.new(current_user.spotify).display_name
        @round_title = get_round_title(@current_genre)
        @next_round = get_next_round_title((@current_genre))
        @next_round_day = get_next_round_day
        @next_bracket_day = @current_genre.next_day
        @on_submitted_genre = false

        if current_user.song
          @song = RSpotify::Track.find(current_user.song.track_id)
          @submitted_genre = current_user.song.genre
          @submitted_genre_name = @submitted_genre.format_genre
          set_notification
          if @current_genre == @submitted_genre
            @on_submitted_genre = true
          end
        end
        if current_user.artist_id
          @artist = RSpotify::Artist.find(current_user.artist_id)
        end
        if @current_genre.state == "ended"
          winner = Winner.active.where(genre: @current_genre.name).first
          @winning_song = RSpotify::Track.find(winner.track_id)
          @winning_artist = @winning_song.artists[0]
        end
      end
    end
  end

  def clear_notification
    current_user.update_attribute("notification", nil)
    flash.discard
    redirect_to root_path
  end

  private
  def set_notification
    if current_user.notification == "bye"
      flash[:notice] = "Your submission got a bye, so it will automatically progress to Round 2!"
    elsif current_user.notification == "won"
      flash[:notice] = "Congratulations! Your submission won the previous round."
    elsif current_user.notification == "lost"
      flash[:notice] = "Unfortunately, your submission lost the previous round."
    end
  end

  def get_next_round_day
    require 'date'
    today = Date.today.wday
    # if today is friday, saturday, or sunday
    if today > 4
      return "Monday"
    # if today is monday, tuesday, wednesday, or thursday
    else
      return "Friday"
    end
  end


  def get_next_bracket_day(genre)
    require 'date'
    if genre.next_day == "Friday"
        return "Monday"
    elsif genre.next_day == "Monday"
      return "Friday"
    end
  end
  
  def get_round_title(genre)
    songs_left = genre.songs.active.count
    if songs_left == 8
      return "Quarterfinals"
    elsif songs_left == 4
      return "Semifinals"
    elsif songs_left == 2
      return "Finals"
    else
      return "Round #{genre.round}"
    end
  end
  
  def get_next_round_title(genre)
    songs_left = genre.songs.active.count
    if songs_left == 8
      return "the Semifinals"
    elsif songs_left == 4
      return "the Finals"
    elsif songs_left == 2
      return "the winner"
    else
      return "Round #{genre.round + 1}"
    end
  end



end


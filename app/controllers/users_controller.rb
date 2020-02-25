class UsersController < ApplicationController
  def show
    @user = RSpotify::User.new(current_user.spotify)
    @display_name = RSpotify::User.new(current_user.spotify).display_name

    if current_user.song
      @song = RSpotify::Track.find(current_user.song.track_id)
      @submitted_genre = (current_user.song.genre).format_genre
      @state = current_user.song.genre.state
    end
    if current_user.artist_id?
      @artist = RSpotify::Artist.find(current_user.artist_id)
    end
  end

  def edit
    if current_user.song
      if current_user.song.genre.state == 'in progress'
        redirect_to root_path
      end
    else
      @user = current_user
      @display_name = RSpotify::User.new(current_user.spotify).display_name
      if !(current_user.genre)
        render 'select_current_genre'
      else
        render 'link_artist'
      end
    end 
  end

  def toggle_notifications
    @user = current_user
    if @user.email_preference == "round"
      @user.update_attribute("email_preference", "off")
    else
      @user.update_attribute("email_preference", "round")
    end
    redirect_to user_path(current_user)
  end

  def select_current_genre
    @user = current_user
    @display_name = RSpotify::User.new(current_user.spotify).display_name
  end

  def update
    @user = current_user
    # if artist_id is present in the params, sanitize it
    if params["user"]['artist_id'].present?
      sanitize_artist_id
    end
    if @user.update(user_params)
      if params["user"]['artist_id'].present?
        redirect_to(new_song_path)
      else
        redirect_to root_path
      end
    else
      # unless @user.errors.messages[0].empty?
        redirect_to(edit_user_path(current_user), :notice => @user.errors.messages[:artist_id][0])
      # end
    end
  end

  private
  def user_params
    params.require(:user).permit(:artist_id, :genre, :genre_id)
  end

  def sanitize_artist_id
    artist_id = params[:user][:artist_id].strip
    if artist_id.start_with?('spotify:artist:')
      params[:user][:artist_id] = artist_id[15..-1]
    end
  end

end
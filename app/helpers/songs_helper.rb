module SongsHelper
  def formatTrackDuration(duration_ms)
    minutesAndSeconds = (duration_ms.to_f/60000.to_f).divmod 1
    minutes = minutesAndSeconds[0]
    seconds = minutesAndSeconds[1] * 60
    if seconds < 9.5
      "#{minutes}:0#{seconds.round}"
    else
      "#{minutes}:#{seconds.round}"
    end
  end
end

$(document).on("turbolinks:load", function() {
  $('.selectRadioButton').click(function(){
    $('.selectRadioButton').removeClass("active");
    $(this).addClass("active");
    $('#enterTrackButton').removeClass("disabled");
    $('#enterTrackButton').removeClass("btn-secondary");
    $('#enterTrackButton').removeAttr("disabled");
    $('#enterTrackButton').addClass("btn-primary");
  }); 

  $('.voteNowButton').click(function(){
    $('.preVoting').addClass("animated fadeOut fast")
  }); 

  $('.voteRadioButton').click(function(){
    $('.voteRadioButton').removeClass("active")
    $(this).addClass("active")
    $('#nextVoteButton').removeClass("disabled")
    $('#nextVoteButton').removeClass("btn-secondary")
    $('#nextVoteButton').addClass("btn-primary")
    $('#nextVoteButton').removeAttr("disabled");
  }); 

  $('.genreRadioButton').click(function(){
    $('.genreRadioButton').removeClass("active")
    $(this).addClass("active")
    $('#selectGenreButton').removeClass("disabled")
    $('#selectGenreButton').removeClass("btn-secondary")
    $('#selectGenreButton').addClass("btn-primary")
    $('#selectGenreButton').removeAttr("disabled");
  }); 


  $('.close-modal').click(function() {
    $( "#notif_modal" ).hide();
    $( ".dimmed" ).hide();
  });

  $('.tracklist').on('scroll', function() {
    if($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight - 2) {
       $(".tracklist").css("boxShadow", "none");
    } else
       $(".tracklist").css("boxShadow", "inset 0 -12px 4px -8px #111");
  })

  $('#enterTrackButton').click(function(){
    var track_name = $(".active").name
    $('.modal').text(track_name)
    console.log("as")
  }); 


  if ($(".submitSongPage")[0]){
    $("html").css("overflow-y", "scroll");
  }


function getNextDayOfTheWeek(dayName, excludeToday = true, refDate = new Date()) {
    const dayOfWeek = ["sun","mon","tue","wed","thu","fri","sat"]
                      .indexOf(dayName.slice(0,3).toLowerCase());
    if (dayOfWeek < 0) return;
    refDate.setHours(0,0,0,0);
    refDate.setDate(refDate.getDate() + +!!excludeToday + 
                    (dayOfWeek + 7 - refDate.getDay() - +!!excludeToday) % 7);
    return refDate;
}

if( $('#countdown').length ) {
  // Set the date we're counting down to
  var countDownDate = getNextDayOfTheWeek($(".nextBracketDay").text());
  // nextBracketDate($(".nextBracketDay").innerHTML);

  // Update the count down every 1 second
  var x = setInterval(function() {

    // Get today's date and time
    var now = new Date().getTime();

    // Find the distance between now and the count down date
    var distance = countDownDate - now;

    // Time calculations for days, hours, minutes and seconds
    var days = Math.floor(distance / (1000 * 60 * 60 * 24));
    var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
    var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
    var seconds = Math.floor((distance % (1000 * 60)) / 1000);

    // Display the result in the element with id="demo"
    document.getElementById("countdown").innerHTML = days + "d " + hours + "h "
    + minutes + "m " + seconds + "s ";

    // If the count down is finished, write some text
    if (distance < 0) {
      clearInterval(x);
      document.getElementById("countdown").innerHTML = "Starting Soon";
    }
  }, 1000);
}

});


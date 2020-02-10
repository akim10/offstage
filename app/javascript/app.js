$(document).on("turbolinks:load", function() {
  $('.selectRadioButton').click(function(){
    $('.selectRadioButton').removeClass("active");
    $(this).addClass("active");
    $('#submitTrackButton').removeClass("disabled");
    $('#submitTrackButton').removeClass("btn-secondary");
    $('#submitTrackButton').removeAttr("disabled");
    $('#submitTrackButton').addClass("btn-primary");
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

  $('#submitTrackButton').click(function(){
    var track_name = $(".active").name
    $('.modal').text(track_name)
    console.log("as")
  }); 

});
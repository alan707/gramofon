$(function() {
    $('.like-button').click(function(){
        $(this).toggleClass('liked')
    });
    
    $('.post-date').each(function() {
        var $el = $(this);
        var fromNow = moment.unix($el.data('timestamp')).fromNow();
        $el.text(fromNow);
    });
    
//    $(window).scroll(function() {
//        if ( $(window).scrollTop() > 45 ) {
//            $('.sidebar').css({ position: "fixed", top: 45 });
//        } else {
//            $('.sidebar').css({ position: "static" });
//        }
//    });
    
    audiojs.events.ready(function() {
        var as = audiojs.createAll();
    });
    
    if ( $('#map').length > 0 ) {
        var isInit=false;
        var myLatlng = new google.maps.LatLng(42.281 ,-83.738609)
        var mapOptions = {
            zoom: 14,
            center: myLatlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);

        if(!isInit){
            initialize(map);
        }
        isInit = false;
    }
    
    $('.share-button').click(function(event){
        var target = $(event.target),
            clipId = target.data('clip-id'),
            clipTitle = target.data('clip-title');
            
        var clipUrl = window.location.origin + '/clip/' + clipId;
            
        FB.ui(
              {
                method: 'feed',
                name: clipTitle,
                link: clipUrl,
                caption: 'Share the sound of your life',
                picture: window.location.origin + '/gramofon-logo-facebook.jpg'
              },
              function(response) {
                if (response && response.post_id) {
                  console.log('Link shared');
                } else {
                  alert('Post was not published.');
                }
              }
            );
        
        
    })
    
});

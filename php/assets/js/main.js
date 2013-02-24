$(function() {
    $('.like-button').click(function(){
//        var $this = $(this),
//            clipId = $this.closest('[data-clip-id]').data('clip-id'),
//            url;
            
        $(this).toggleClass('liked')
        
//        if ( $(this).hasClass('liked') ) {
//            url = '/clip/' + clipId + '/like';
//        } else {            
//            url = '/clip/' + clipId + '/unlike';
//        }
//        
//        $.post(url);
    });
    
    $('.post-date').each(function() {
        var $el = $(this);
        var fromNow = moment.unix($el.data('timestamp')).fromNow();
        $el.text(fromNow);
    });
    
    $('.share-button').click(function(event){
        var target = $(event.target),
            clipId = target.data('clip-id'),
            clipTitle = target.data('clip-title');
            
        var clipUrl = window.location.origin + '/clip/' + clipId;
            
        FB.ui({
            method: 'feed',
            name: clipTitle,
            link: clipUrl,
            caption: 'Share the sound of your life',
            picture: window.location.origin + '/images/gramofon-logo-facebook.jpg'
        },function(response) {
            if (response && response.post_id) {
//                console.log('Link shared');
            } else {
//                alert('Post was not published.');
            }
        });
    })
    
});

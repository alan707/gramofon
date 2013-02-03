$(function() {
    $('.post-date').each(function() {
        var $el = $(this);
        var fromNow = moment.unix($el.data('timestamp')).fromNow();
        $el.text(fromNow);
    });
    
    $(window).scroll(function() {
        if ( $(window).scrollTop() > 45 ) {
            $('.sidebar').css({ position: "fixed", top: 0 });
        } else {
            $('.sidebar').css({ position: "static" });
        }
    });
    
    audiojs.events.ready(function() {
        var as = audiojs.createAll();
    });
});

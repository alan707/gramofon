$(function() {
    $('.post-date').each(function() {
        var $el = $(this);
        var fromNow = moment.unix($el.data('timestamp')).fromNow();
        $el.text(fromNow);
    })
    
    audiojs.events.ready(function() {
        var as = audiojs.createAll();
    });
});

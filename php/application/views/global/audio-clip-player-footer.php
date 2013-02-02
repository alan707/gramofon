<script type="text/javascript">
    $( document ).ready( function() {
        $('.from-now').each(function(index){
            el = $(this);
            var date = new Date(el.attr('year'),el.attr('month'),el.attr('day'),el.attr('hour'),el.attr('minute'),el.attr('second'));
            var fm = moment(date).fromNow();
            el.text(fm)
        })
    });
</script>

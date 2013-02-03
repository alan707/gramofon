<script>
    var map;
    function initialize() {
        latlng = new google.maps.LatLng(33.4222685, -111.8226402)
        myOptions = {
            zoom: 4,
            center: latlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        };
        map = new google.maps.Map(document.getElementById("map"),myOptions)
        var point = new google.maps.LatLng(33.4222685, -111.8226402);
        var marker = new google.maps.Marker({
            position: point,
            map: map
        })
        google.maps.event.addListener(marker, "click", function(){
            bubble = new google.maps.InfoWindow({
                content: "<audio controls id='my-audio'><source src='/dummyfiles/Example.m4a' type='audio/mp4; codecs=\"mp4a.40.5\"'></audio>"
            })
            bubble.open(map, marker);
        })
    }
</script>

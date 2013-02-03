<? $this->load->view('global/header.php') ?>
<script src="http://maps.google.com/maps/api/js?sensor=false"></script>
<body>

<div class="row">
    <div class="nine columns">
    <script>
        function getPoints(map){
            var ps = new Array();
            <? foreach( $audio_clips as $clip ) : ?>
                <? if (!empty($clip->latitude) && !empty($clip->longitude)): ?>
                var point = new Object();
                point.marker =  new google.maps.Marker({
                         position: new google.maps.LatLng(<? echo $clip->latitude ?>,<? echo $clip->longitude ?>),
                         map: map,
                         title:'<? echo $clip->title ?>',
                         src:'<? echo $clip->sound_file->url ?>'

                     });
                point.infowindow = new google.maps.InfoWindow({
                    content: "<h2><? echo $clip->title ?></h2>",
                });
                point.marker.infowindow =point.infowindow;
                ps[ps.length] = point;

            <? endif; ?>
        <? endforeach; ?>
            return ps;
        }

    </script>
    <style >
        #map img {
            max-width: none;
        }
    </style>
    <div class="row">
        <div class="audio-player">
            <h3 id='audio-title'>Click a Marker to play</h3>
            <audio  type="audio/mp4"></audio>
        </div>
          <div id="map"  style="width: 800px; height: 495px" class="map"></div>
          <script>
                    function initialize(map) {
                        $(function() {
                            var a = audiojs.createAll();

                            // Load in the first track
                            var audio = a[0];

                            ps = getPoints(map);
                            for(var i=0;i<ps.length;i++){
                                marker = ps[i].marker;
                                google.maps.event.addListener(marker, 'click', function() {
                                    //this.infowindow.open(map,this);
                                    audio.load(this.src);
                                    audio.play();
                                    $('#audio-title').text(this.title);
                                });
                                google.maps.event.addListener(marker, 'mouseover', function() {
                                    this.infowindow.open(map,this);
                                });
                                google.maps.event.addListener(marker, 'mouseout', function() {
                                    this.infowindow.close();
                                });
                            }
                        });
                    }
                </script>
            </div>
        <!-- end iterating over audio_clip array here -->
    </div>

    <div class="three columns">

    </div>
    <!--- <h4>"+ps[marker.index].title+"</h4>-->
</div>
<
<? $this->load->view('global/footer.php') ?>
<script type="text/javascript">
    $( document ).ready( function() {
        var myLatlng = new google.maps.LatLng(42.28 ,-83.738609)
        var mapOptions = {
            zoom: 15,
            center: myLatlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);

      initialize(map);
    });
</script>
</body>
</html>
<script src="http://maps.google.com/maps/api/js?sensor=false"></script>

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
            .audio-player{
                display:none;
            }
        </style>
        <div class="row">
            <h3 id='audio-title'>Click a Marker to play</h3>
            <div class="audio-player">
                <audio  preload='none' type="audio/mp4" />
            </div>
            <div id="map"  style="width: 800px; height: 495px" class="map"></div>
            <script>
                function isAppLoaded()
                {
                    
                    return true;
                }
                function loadAudio(uri)
                {
                    var audio = new Audio();
                    //audio.onload = isAppLoaded; // It doesn't works!
                    audio.addEventListener('canplaythrough', isAppLoaded, false); // It works!!
                    audio.src = uri;
                    return audio;
                }
                function initialize(map) {
                    $(function() {
                        var a = audiojs.createAll();

                        // Load in the first track
                        var audio = a[0];

                        ps = getPoints(map);
                        for(var i=0;i<ps.length;i++){
                            marker = ps[i].marker;
                            loadAudio(marker.src);
                            google.maps.event.addListener(marker, 'click', function() {
                                //this.infowindow.open(map,this);
                                audio.load(this.src);
                                audio.play();
                                $('#audio-title').text('Playing: '+this.title);
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
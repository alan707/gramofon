<? $this->load->view('global/header.php') ?>

<div class="row audio-feed">
    
    <? $this->load->view('global/user-view-subnav.php', array( 'view' => 'map' )) ?>

    <!-- start iterating over audio_clip array here -->
    <? $this->load->view('global/user-map-data.php', array( 'audio_clips' => $user->audio_clips )) ?>
    <!-- end iterating over audio_clip array here -->

</div>

<? $this->load->view('global/footer.php') ?>
<script type="text/javascript">
    var isInit=false;
    $( document ).ready( function() {
        var myLatlng = new google.maps.LatLng(42.281 ,-83.738609)
        var mapOptions = {
            zoom: 16,
            center: myLatlng,
            mapTypeId: google.maps.MapTypeId.ROADMAP
        }
        var map = new google.maps.Map(document.getElementById("map"), mapOptions);

        if(!isInit){
            initialize(map);
        }
        isInit = false;
    });
</script>
<? $this->load->view('global/header.php') ?>

<div class="row user-block">
    <div class="user-block-image-wrapper two columns">

        <img class="user-block-image" src="<?= $user->profile_picture ?>" />
    </div>

    <div class="user-block-details-wrapper ten columns">
        <h2 class="user-block-name"><?= $user->firstname ?> <?= $user->lastname ?></h2>
        <a href="" class="user-block-username"><?= $user->username ?></a><a class="tiny button user-follow-button" href="#">Follow</a>
        <div><?= sizeof($user->audio_clips) ?> sounds</div>
        <div>42 Plays</div>
        <div>77 Followers</div>
        <div>21 Following</div>
    </div>
</div>

<div class="row audio-feed">

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
            zoom: 18,
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
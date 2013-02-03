<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="twelve columns">
        <dl class="sub-nav">
            <dt>View:</dt>
            <dd class="active"><a href="/">Feed</a></dd>
            <dd><a href="/map">Map</a></dd>
        </dl>
    </div>
</div>
    
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
    <div class="twelve columns ">
    
        <? $this->load->view('global/view-subnav.php', array( 'view' => 'feed' )) ?>

    <? if ( !empty($user->audio_clips) ) : ?>
        <span>Sorry... no sounds yet</span>
    <? endif; ?>

    <!-- start iterating over audio_clip array here -->
    <? foreach( $user->audio_clips as $clip ) : ?>
        <div class="row">
            <div class="twelve columns ">
                <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $clip )) ?>
            </div>
        </div>  
    <? endforeach; ?>
    <!-- end iterating over audio_clip array here -->
    </div>
</div>  

<? $this->load->view('global/footer.php') ?>
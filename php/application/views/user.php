<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="eight columns ">
        <? if ( !empty($user->audio_clips) ) : ?>
            <? foreach( $user->audio_clips as $clip ) : ?>
                <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $clip )) ?>
            <? endforeach; ?>
        <? else : ?>
            <span>Sorry... no sounds yet</span>
        <? endif; ?>
    </div>
    
    <div class="four columns">
        <? $this->load->view('user-sidebar.php') ?>
    </div>
</div>  

<? $this->load->view('global/footer.php') ?>
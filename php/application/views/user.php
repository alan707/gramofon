<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="eight columns ">
    
        <? $this->load->view('global/view-subnav.php', array( 'view' => 'feed' )) ?>

    <? if ( !empty($user->audio_clips) ) : ?>
        <!-- start iterating over audio_clip array here -->
        <? foreach( $user->audio_clips as $clip ) : ?>
            <div class="row">
                <div class="twelve columns ">
                    <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $clip )) ?>
                </div>
            </div>  
        <? endforeach; ?>
    <? else : ?>
        <span>Sorry... no sounds yet</span>
    <? endif; ?>
    <!-- end iterating over audio_clip array here -->
    </div>
    
    <div class="four columns">
        <? $this->load->view('user-sidebar.php') ?>
    </div>
</div>  

<? $this->load->view('global/footer.php') ?>
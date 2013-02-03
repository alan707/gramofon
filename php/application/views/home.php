<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="twelve columns">
    </div>
</div>

<div class="row">
    <div class="eight columns">
        <? $this->load->view('global/view-subnav.php', array( 'view' => 'feed' )) ?>
        
        <? if ( !empty($audio_clips) ) : ?>
            <!-- start iterating over audio_clip array here -->
            <? foreach( $audio_clips as $clip ) : ?>
                <div class="row">
                    <div class="twelve columns">
                        <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $clip )) ?>
                    </div>
                </div>
            <? endforeach; ?>
            <!-- end iterating over audio_clip array here -->
        <? else : ?>
            <div class="row">
                <div class="twelve columns">
                    Sorry... no sounds yet
                </div>
            </div>
        <? endif; ?>
    </div>
    
    <div class="four columns">
        <? $this->load->view('home-sidebar.php') ?>
    </div>
</div>

<? $this->load->view('global/footer.php') ?>

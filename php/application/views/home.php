<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="nine columns">
        
        <? if ( !empty($audio_clips) ) : ?>
            <!-- start iterating over audio_clip array here -->
            <? foreach( $audio_clips as $clip ) : ?>
                <div class="row">
                    <div class="two columns audio-feed">
                        <h5><? echo $clip->username ?></h5>
                    </div>
                    <div class="ten columns audio-feed">
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
    
    <div class="three columns">
        <? $this->load->view('home-sidebar.php') ?>
    </div>

</div>

<? $this->load->view('global/footer.php') ?>
<? $this->load->view('global/audio-clip-player-footer.php') ?>
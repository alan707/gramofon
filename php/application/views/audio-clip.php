<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="eight columns">
        <div class="row">
            <div class="twelve columns audio-feed">
                <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $audio_clip )) ?>
            </div>
        </div>
    </div>    
    
    <div class="four columns">
        <? $this->load->view('home-sidebar.php') ?>
    </div>
</div>

<? $this->load->view('global/footer.php') ?>
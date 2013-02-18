<? $this->load->view('global/header.php') ?>

<? $this->load->view('global/audio-clip-player.php', array( 'clip' => $audio_clip )) ?>

<div class="row">
    <div class="twelve columns">
        <div class="fb-comments" data-href="/clip/<?= $audio_clip->id ?>" data-num-posts="20"></div>  
    </div>
</div>
    
<? $this->load->view('global/footer.php') ?>
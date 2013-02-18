<? $this->load->view('global/header.php') ?>

<? if ( !empty($audio_clips) ) : ?>
    <? foreach( $audio_clips as $clip ) : ?>
        <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $clip )) ?>                
    <? endforeach; ?>
<? else : ?>
    <div class="row">
        <div class="twelve columns">
            Sorry... no sounds yet
        </div>
    </div>
<? endif; ?>

<? $this->load->view('global/footer.php') ?>

<? $this->load->view('global/header.php') ?>

<? if ( !empty($audio_clips) ) : ?>
    <div class="clip-feed">
        <? foreach( $audio_clips as $clip ) : ?>
            <? $this->load->view('global/audio-clip.php', array( 'clip' => $clip )) ?>                
        <? endforeach; ?>
    </div>
<? else : ?>
    <div class="row">
        <div class="twelve columns">
            Sorry... no sounds yet
        </div>
    </div>
<? endif; ?>

<? $this->load->view('global/footer.php') ?>

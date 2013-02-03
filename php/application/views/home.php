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

<div class="row">
    <div class="eight columns">
        <? if ( !empty($audio_clips) ) : ?>
            <!-- start iterating over audio_clip array here -->
            <? foreach( $audio_clips as $clip ) : ?>
                <div class="row">
                    <div class="twelve columns audio-feed">
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
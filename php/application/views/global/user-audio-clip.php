<div class="row audio-clip">
    <div class="twelve columns">
        <h3 class="clip-title">
            <a href="/clip/<?= $clip->id ?>"><?= ( !empty($clip->title) ) ? character_limiter($clip->title, 24) : 'untitled' ?></a>
        </h3>

        <? $this->load->view('global/audio-player') ?>

        <div class="clip-metadata">
            <span class="post-date" data-timestamp="<?= $clip->created ?>"></span> near 
            <span class="location"><?= empty($clip->venue) ? 'Unknown' : character_limiter($clip->venue, 30) ?></span>            
        </div>
    </div>
</div>
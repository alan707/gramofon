<div class="row audio-clip">
    <div class="four columns mobile-one user-photo">
        <a href="/<?= $clip->username ?>" 
           title="<?= $clip->username ?>"
           style="background-image:url(<?= $clip->photo ?>)"></a>
    </div>
    
    <div class="eight columns mobile-three">
        <h3 class="clip-title">
            <a href="/clip/<?= $clip->id ?>"><?= ( !empty($clip->title) ) ? character_limiter($clip->title, 24) : 'untitled' ?></a>
        </h3>

        <? $this->load->view('global/audio-player') ?>

        <div class="clip-metadata">
            <span class="post-date" data-timestamp="<?= $clip->created_at ?>"></span> near 
            <span class="location"><?= empty($clip->fsvenue) ? 'Unknown' : character_limiter($clip->fsvenue, 30) ?></span>            
        </div>
    </div>
</div>
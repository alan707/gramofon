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

        <div class="audio-player">
            <div class="action-button like-button">
                <i class="icon-heart"></i>
                <span class="count"><?= rand(0, 25) ?></span>
            </div>

            <div class="share-button action-button icon-share" data-clip-id="<?= $clip->id ?>" data-clip-title="<?= $clip->title ?>"></div>
        
            <div class="audio-player-btn audio-playet-btn-play icon-play" data-sid="<?= $clip->id ?>"></div>

            <div class="audio-player-progress-wrapper">
                <div class="audio-player-progress"></div>
            </div>
        </div>

        <div class="clip-metadata">
            <span class="post-date" data-timestamp="<?= $clip->created_at ?>"></span> near 
            <span class="location"><?= empty($clip->fsvenue) ? 'Unknown' : character_limiter($clip->fsvenue, 30) ?></span>            
        </div>
    </div>
</div>
<script>
        GF.registerSoundClip('<?= $clip->id ?>', '<?= $clip->sound_file->url ?>');
</script>
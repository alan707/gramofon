<div class="audio-clip">
    <div class="user-photo">
        <img src="/images/user-photo.jpg" width="65" height="65" alt="">
    </div>
    
    <div class="audio-clip-info">
        <h3 class="audio-clip-title"><?= ( !empty($clip->title) ) ? $clip->title : 'untitled' ?></h3>
        
        <div class="audio-player">
            <audio src="<? echo $clip->sound_file->url ?>" type="audio/mp4"></audio>
        </div>
        
        <div class="audio-clip-metadata">
            <span class="post-date" data-timestamp="<?= $clip->created_at ?>"></span> near <span class="location">Rackham</span>            
            <div class="category"><span class="label">outdoors</span></div>
        </div>
    </div>
</div>
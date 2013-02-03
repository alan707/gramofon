<div class="audio-clip">
    <div class="user-photo"></div>
    
    <div class="audio-clip-info">
        <h3 class="audio-clip-title"><?= $clip->title ?></h3>
        <audio src="<? echo $clip->sound_file->url ?>" type="audio/mp4"></audio>
        <div class="post-date" data-timestamp="<?= $clip->created_at ?>"></div>
    </div>
</div>
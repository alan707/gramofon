<div class="audio-player" data-clip-id="<?= $clip->id ?>" data-clip-url="<?= $clip->sound_file_url ?>">
    <div class="action-button like-button">
        <i class="icon-heart"></i>
        <span class="count"><?= rand(0, 25) ?></span>
    </div>

    <div class="share-button action-button icon-share" data-clip-id="<?= $clip->id ?>" data-clip-title="<?= $clip->title ?>"></div>

    <div class="audio-player-btn audio-player-btn-play icon-play"></div>

    <div class="audio-player-progress-wrapper">
        <div class="audio-player-progress"></div>
    </div>
</div>
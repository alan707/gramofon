<div class="audio-clip-wrapper">
    <h3 class="audio-clip-title"><?= $clip->title ?></h3>
    <div class="audio-clip-player ten columns">
        <div class="audio-clip-player-play">
            <i class="icon-play"></i>
        </div>
        <span class="audio-clip-player-visualizer"></span>
    </div>
    <ul class="audio-clip-actions">
        <li class="audio-clip-actions-item" >
            <i class="icon-heart-empty"></i>
        </li>
        <li class="audio-clip-actions-item" >
            <i class="icon-share"></i>
        </li>
        <li class="audio-clip-actions-item" >
            <i class="icon-comments"></i>
        </li>
    </ul>
    <div class="audio-clip-footer">
        <span class="audio-clip-date icon-time"><?= $clip->date ?></span>
        <span class="audio-clip-location  icon-map-marker">U of M</span>
    </div>
</div>
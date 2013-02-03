<?
    $categories = array(
        'outdoors',
        'ambient',
        'conversation',
        'comedy',
        'music',
        'animals',
        'urban',
        'sporting'
    );
    
    shuffle($categories);
?>
<div class="audio-clip">
    <div class="user-photo">
        <img src="/images/user-photo.jpg" width="65" height="65" alt="">
    </div>
    
    <div class=" action-button play-count">
        <span class="count"><?= rand(0, 50) ?></span>
        <i class="icon-play"></i>
    </div>
    
    <div class=" action-button like-button">
        <i class="icon-heart"></i>
        <span class="count"><?= rand(0, 25) ?></span>
    </div>
    
    <div class="share-button action-button" data-clip-id="<?= $clip->id ?>" data-clip-title="<?= $clip->title ?>">
        <i class="icon-share"></i>
    </div>
    
    <div class="audio-clip-info">
        <h3 class="audio-clip-title">
            <a href="/clip/<?= $clip->id ?>"><?= ( !empty($clip->title) ) ? character_limiter($clip->title, 24) : 'untitled' ?></a>
        </h3>
        
        <div class="audio-player">
            <audio src="<? echo $clip->sound_file->url ?>" type="audio/mp4"></audio>
        </div>
        
        <div class="audio-clip-metadata">
            <span class="post-date" data-timestamp="<?= $clip->created_at ?>"></span> near <span class="location"><?= empty($clip->fsvenue) ? 'Unknown' : character_limiter($clip->fsvenue, 30) ?></span>            
            <div class="category"><span class="label"><?= $categories[0] ?></span></div>
        </div>
    </div>
</div>
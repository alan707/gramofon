<?
    $user_photos = array(
        'amond'    => 'http://profile.ak.fbcdn.net/hprofile-ak-ash3/s200x200/530565_10102950454612124_1281285938_n.jpg',
        'benchutz' => 'http://profile.ak.fbcdn.net/hprofile-ak-ash3/s320x320/543221_10102885910389264_515121620_n.jpg',
        'dtrenz'   => 'http://profile.ak.fbcdn.net/hprofile-ak-ash4/s200x200/293575_10151404780873832_883004756_n.jpg',
        'raul'     => 'http://profile.ak.fbcdn.net/hprofile-ak-snc6/168690_490367046461_326319_n.jpg',
        'Chris'    => 'http://profile.ak.fbcdn.net/hprofile-ak-ash4/s320x320/407312_10100531205646645_182024679_n.jpg'
    );
    
    if ( isset($user_photos[$clip->username]) ) {        
        $user_photo = $user_photos[$clip->username];
    } else {
        $user_photo = '/images/user-photo.jpg';
    }
    
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
        <a href="/<?= $clip->username ?>" title="<?= $clip->username ?>"><img src="<?= $user_photo ?>" alt="<?= $clip->username ?>"></a>
    </div>
    
    <div class=" action-button play-count">
        <span class="count"><?= rand(0, 50) ?></span>
        <i class="icon-play"></i>
    </div>
    
    <div class=" action-button like-button">
        <i class="icon-heart"></i>
        <span class="count"><?= rand(0, 25) ?></span>
    </div>
    
    <div class="share-button action-button icon-share" data-clip-id="<?= $clip->id ?>" data-clip-title="<?= $clip->title ?>">
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
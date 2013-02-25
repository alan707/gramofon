<div class="row audio-clip">
    <div class="four columns mobile-one user-photo">
        <? 
        if ( !empty($clip->user_facebook_id) ) :
            $clip->photo = get_facebook_profile_picture($clip->user_facebook_id, array( 'width' => 210 ));
        endif; 
        ?>
        
        <? if ( !empty($clip->user->username) ) : ?>
            <a href="/<?= $clip->user->username ?>" 
               title="<?= $clip->user->username ?>"
               style="<?= ( !empty($clip->photo) ) ? "background-image:url({$clip->photo})" : '' ?>"></a>
        <? endif; ?>
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
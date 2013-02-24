<? $this->load->view('global/header.php') ?>

<div class="row">
    <div class="four columns push-eight sidebar">
        <div class="row">
             <div class="twelve columns mobile-one user-photo">
                 <img 
                     class="user-block-image" 
                     src="<?= get_facebook_profile_picture($user->facebook_id, array( 'width' => 200, 'height' => 200 )) ?>"
                     width="200"
                     height="200"
                     alt="<?= $user->username ?>">
            </div>

            <div class="twelve columns mobile-three">
                <h4 class="user-block-name"><?= $user->firstname ?> <?= $user->lastname ?></h4>
                
                <div class="stats">        
                    <ul>
                        <li>
                            <?= $user->clip_count . ( ( $user->clip_count == 1 ) ? ' clip' : ' clips' ) ?>
                        </li>
                    </ul>
                </div>
            </div>
        </div>
    </div>
    
    <div class="eight columns pull-four">
        <? if ( !empty($user->audio_clips) ) : ?>
            <? foreach( $user->audio_clips as $clip ) : ?>
                <? $this->load->view('global/user-audio-clip.php', array( 'clip' => $clip) ) ?>
            <? endforeach; ?>
        <? else : ?>
            <span>Sorry... no sounds yet</span>
        <? endif; ?>
    </div>
</div>  

<? $this->load->view('global/footer.php') ?>
<? $this->load->view('global/header.php') ?>
    <div class="twelve columns">
    
        <div class="row user-block">
            <div class="user-block-image-wrapper two columns">
                <img class="user-block-image" src="http://www.androidtablets.net/forum/attachments/sylvania-tablets/4266d1318424401-what-mini-tablet-express-plus-nailed_it_re_20th_century_fox_theme_on_flute-s240x320-227191.jpg" />
            </div>

            <div class="user-block-details-wrapper ten columns">
                <h2 class="user-block-name"><?= $user->firstname ?> <?= $user->lastname ?></h2>
                <a href="" class="user-block-username"><?= $user->username ?></a><a class="tiny button user-follow-button" href="#">Follow</a>
                <div><?= sizeof($user->audio_clips) ?> sounds</div>
                <div>42 Plays</div>
                <div>77 Followers</div>
                <div>21 Following</div>
            </div>
        </div>
        
        <div class="row audio-feed">
            
            <?php
                if( sizeof($user->audio_clips) == 0):
            ?>
                <span>Sorry... no sounds yet</span>
            
            <?php
                endif;
            ?>

            <!-- start iterating over audio_clip array here -->
            <?php
                foreach($user->audio_clips as $clip):
            ?>
            <div class="twelve columns ">
                <? $this->load->view('global/audio-clip-player.php', array( 'clip' => $clip )) ?>
            </div>
            <?php
                endforeach;
            ?>
            <!-- end iterating over audio_clip array here -->
            
        </div>        
    </div>    

<? $this->load->view('global/footer.php') ?>
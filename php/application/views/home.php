<? $this->load->view('global/header.php') ?>

<div class="row">
    
    <div class="twelve columns user-block">
        <div class="user-block-image-wrapper two columns">
            <img class="user-block-image" src="http://www.androidtablets.net/forum/attachments/sylvania-tablets/4266d1318424401-what-mini-tablet-express-plus-nailed_it_re_20th_century_fox_theme_on_flute-s240x320-227191.jpg" />
        </div>
        
        <div class="user-block-details-wrapper ten columns">
            <h2 class="user-block-name">Ben Chutz</h2>
            <a href="" class="user-block-username">Ben</a>
        </div>
    </div>

    <div class="twelve columns audio-feed">
        <!-- start iterating over audio_clip array here -->
        <div class="audio-clip-wrapper">
            <h3 class="audio-clip-title">Title</h3>
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
                <span class="audio-clip-date icon-time">1h ago</span>
                <span class="audio-clip-location  icon-map-marker">U of M</span>
            </div>
        </div>
        <!-- end iterating over audio_clip array here -->
    </div>

</div>

<? $this->load->view('global/footer.php') ?>
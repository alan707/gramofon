<div class="sidebar">
    <img class="user-block-image" src="<?= $user->profile_picture ?>">

    <h4 class="user-block-name"><?= $user->firstname ?> <?= $user->lastname ?></h4>
    
    <div class="stats">        
        <ul>
            <li>
                <?= $clip_count . ( ( $clip_count == 1 ) ? ' clip' : ' clips' ) ?>
            </li>
        </ul>
    </div>
</div>
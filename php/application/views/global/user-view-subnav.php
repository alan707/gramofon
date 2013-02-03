    <dl class="sub-nav">
        <dd<?= ( $view == 'feed' ) ? ' class="active"' : '' ?>>
            <a href="/<?= $user->username ?>" title="feed view"><i class="icon-th-list"></i> feed</a>
        </dd>
        <dd<?= ( $view == 'map' ) ? ' class="active"' : '' ?>>
            <a href="/<?= $user->username ?>/map" title="map view"><i class="icon-globe"></i> map</a>
        </dd>
    </dl>
<? $this->load->view('global/header.php') ?>

<? if ( !empty($user) ) : ?>
    <? $this->load->view('global/user-view-subnav.php', array( 'view' => 'map' )) ?>
<? else : ?>
    <? $this->load->view('global/home-view-subnav.php', array( 'view' => 'map' )) ?>
<? endif; ?>

<? $this->load->view('global/user-map-data.php') ?>

<? $this->load->view('global/footer.php') ?>
<!DOCTYPE html>
<!--[if lt IE 7]>      <html class="no-js lt-ie9 lt-ie8 lt-ie7"> <![endif]-->
<!--[if IE 7]>         <html class="no-js lt-ie9 lt-ie8"> <![endif]-->
<!--[if IE 8]>         <html class="no-js lt-ie9"> <![endif]-->
<!--[if gt IE 8]><!--> <html class="no-js"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="description" content="">
        <meta name="viewport" content="width=device-width">
        
        <title>gramofon</title>
        
        <link rel="stylesheet" href="/css/webfont/webfont.css">
        <link rel="stylesheet" href="/css/foundation.css">
        <link rel="stylesheet" href="/css/gramofon.css">        
        <link rel="stylesheet" href="/css/font-awesome.min.css">
    </head>
    <body>
        
        <div id="fb-root"></div>
        
        <script>(function(d, s, id) {
          var js, fjs = d.getElementsByTagName(s)[0];
          if (d.getElementById(id)) return;
          js = d.createElement(s); js.id = id;
          js.src = "//connect.facebook.net/en_US/all.js#xfbml=1&appId=494330727285381";
          fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));</script>
        
        <!--[if lt IE 7]>
            <p class="chromeframe">You are using an <strong>outdated</strong> browser. Please <a href="http://browsehappy.com/">upgrade your browser</a> or <a href="http://www.google.com/chromeframe/?redirect=true">activate Google Chrome Frame</a> to improve your experience.</p>
        <![endif]-->
        
        <nav class="top-bar contain-to-grid">
            <ul>
                <li class="name">
                    <h1>
                        <a href="/">
                            <img src="/images/logo-small.png" alt="gramafon" width="90" height="30">
                        </a>
                    </h1>
                </li>
            </ul>
            
            <ul class="right">
                <li class="divider show-for-medium-and-up"></li>
                
            <? if ( isset($me->username) ) : ?>
                <li class="has-dropdown name">
                    <a href="/<?= $me->username ?>"><?= $me->firstname . ' ' . $me->lastname ?></a>
                    <ul class="dropdown">
                      <li><a href="/<?= $me->username ?>">My Sounds</a></li>
                      <li><a href="/logout">Logout</a></li>
                    </ul>
                </li>                
            <? else : ?>
                <li class="name">
                    <a href="<?= $this->facebook->getLoginUrl(array( 'scope' => 'email' )) ?>">
                        <img src="/assets/images/fb-login-btn-small.png">
                    </a>
                </li>
            <? endif; ?>
                
            </ul>
        </nav>
        
        <div id="content" class="row">
            <div class="ten columns centered">
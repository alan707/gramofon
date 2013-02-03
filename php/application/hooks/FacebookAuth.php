<?php

function loadFacebookData() {

    $CI = &get_instance();
    $CI -> config -> load("facebook", TRUE);
    $config = $CI -> config -> item('facebook');
    $CI -> load -> library('facebook', $config);

    // Stop cache
    $CI -> output -> set_header("Cache-Control: private, no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
    $CI -> output -> set_header("Pragma: no-cache");

    // Repopulate _REQUEST ... Facebook needs it.
    $request_uri = $_SERVER['REQUEST_URI'];
    $request_uri = explode('?', $request_uri);
    if (count($request_uri) > 1) {
        parse_str($request_uri[1], $_REQUEST);
    }

    $CI -> load -> library("session");
    $userId = $CI -> facebook -> getUser();
    $userData = '';

    if ($userId) {
        $userData = $CI -> facebook -> api('/me');
        
    } else {
        $userData = '';
    }
    
    $CI->session->set_userdata($userData);
}

<?php

function facebookAuth() {

    $CI = &get_instance();
    
//    // Stop cache
//    $CI -> output -> set_header("Cache-Control: private, no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
//    $CI -> output -> set_header("Pragma: no-cache");
//
//    // Repopulate _REQUEST ... Facebook needs it.
//    $request_uri = $_SERVER['REQUEST_URI'];
//    $request_uri = explode('?', $request_uri);
//    if (count($request_uri) > 1) {
//        parse_str($request_uri[1], $_REQUEST);
//    }
//
//    $CI -> load -> library("session");
//    $userId = $CI -> facebook -> getUser();
    
//    $facebook_user = $CI->facebook->api('/me');
    
    if ( $CI->input->get('state') ) {

        // retrieve facebook user id
        $facebook_id = $CI->facebook->getUser();

        // if we have a facebook user id...
        if ( isset($facebook_id) ) {    
            // lookup the user using the facebook id
            $user = $CI->gramofonclient->get_user_by_facebook_id( $facebook_id );

            // if we are not able to find an existing user...
            if ( $user === FALSE) {
                // get the facebook user data
                $facebook_user = $CI->facebook->api('/me');

                // create a new user from facebook user data
                $user = $CI->gramofonclient->add_facebook_user($facebook_user);
            }

            // if we have an existing or new user...
            if ( $user ) {
                // log them in (set-up session) and set a remember cookie
                $CI->session->set_userdata('user', $user);            
                set_remember_cookie($user->id);
                redirect(current_url(), 'refresh');
            }
        }
    }
}
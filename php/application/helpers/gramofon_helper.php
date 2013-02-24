<?php

/** 
 * Stores the users ID in a 30 day cookie
 * @param int $user_id
 */
function set_remember_cookie( $user_id ) {
    $CI = &get_instance();
    
    $cookie = array(
        'name'   => 'remember',
        'value'  => $user_id,
        'expire' => '2592000'
    );

    $CI->input->set_cookie($cookie);
}

/**
 * Fetches a dynamic facebook profile picture URL for a user.
 * @param int $facebook_id
 * @return string
 */
function get_facebook_profile_picture( $facebook_id, $params = array() ) 
{
    $picture_url = "http://graph.facebook.com/$facebook_id/picture";

    if ( !empty($params) ) {
        $picture_url .= '?' . http_build_query($params);
    }

    return $picture_url;
}
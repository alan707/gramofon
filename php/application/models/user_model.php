<?php

class User_model extends CI_Model {
    
    public function get_user_profile( $username )
    {        
        $user = false;
        
        if ( ! OFFLINE_MODE ) {
            $json = file_get_contents("http://gramofon.herokuapp.com/users/$username.json");
        }

        //grab the facebookID from the users Gramofon profile
        $userFacebookId = json_decode($json);
        $userFacebookId = $userFacebookId->facebook_id;
        
        //use Fb's OpenGraph API to grab their user data (right now only profile picture)
        $facebookJson = file_get_contents("http://graph.facebook.com/" . $userFacebookId . "?fields=name,picture.height(200)");
        
        $facebookData = json_decode($facebookJson);
        
        
        // offline fallback
        if ( empty($json) ) {
            $json = file_get_contents("http://local.usegramofon.com/json/user.json");
        }

        if ( !empty($json) ) {
            $user = json_decode($json);
            $user->profile_picture = $facebookData->picture->data->url;
        }
        
        return $user;
    }
    
    public function get_facebook_profile( $facebook_id )
    {
        $profile = false;
        
        return $profile;
    }
    
}
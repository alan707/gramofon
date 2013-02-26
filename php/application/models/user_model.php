<?php

class User_model extends CI_Model {
    
    public function get_users()
    {
        return $this->gramofonclient->get_users();        
    }

    public function get_user_profile( $username )
    {                
        return $this->gramofonclient->get_user_by_username( $username );

//        //grab the facebookID from the users Gramofon profile
//        $userFacebookId = json_decode($json);
//        $userFacebookId = $userFacebookId->facebook_id;
//        
//        //use Fb's OpenGraph API to grab their user data (right now only profile picture)
//        $facebookJson = file_get_contents("http://graph.facebook.com/" . $userFacebookId . "?fields=name,picture.height(200)");
//        
//        $facebookData = json_decode($facebookJson);
        
      
//        if ( !empty($json) ) {
//            $user = json_decode($json);
//            $user->profile_picture = $facebookData->picture->data->url;
//        }
        
//        return $user;
    }
    
    public function get_facebook_profile( $facebook_id )
    {
        $profile = false;
        
        return $profile;
    }
    
    public function get_facebook_profile_picture( $facebook_id, $width = 0, $height = 0 )
    {
        $picture_url = 'http://graph.facebook.com/dtrenz/picture';
        
        $params = array();
        
        if ( $width ) {
            $params['width'] = $width;
        }
        
        if ( $height ) {
            $params['height'] = $height;
        }
        
        return $picture_url;
    }
    
}
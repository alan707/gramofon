<?php

class User_model extends CI_Model {
    
    public function get_user_profile( $username )
    {        
        $user = false;
        
        $json = file_get_contents("http://gramofon.herokuapp.com/users/$username.json");
        
        if ( !empty($json) ) {
            $user = json_decode($json);
        }
        
        return $user;
    }
    
    public function get_facebook_profile( $facebook_id )
    {
        $profile = false;
        
        return $profile;
    }
    
}
<?php

class User_model extends CI_Model {
    
    public function get_user_profile( $username )
    {
        $user = (object) null;
        $user->username = 'jdoe';
        $user->audio_clips = array();
        
        return $user;
    }
    
}
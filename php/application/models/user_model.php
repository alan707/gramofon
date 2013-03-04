<?php

class User_model extends CI_Model {
    
    public function get_users()
    {
        return $this->gramofonclient->get_users();        
    }

    public function get_user_profile( $username )
    {                
        return $this->gramofonclient->get_user_by_username( $username );
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
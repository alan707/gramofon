<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

/**
 * Client library for the Gramofon API
 * @uses RESTClient 
 */
class GramofonClient {
    
    const BASE_URI = 'http://gramofon.herokuapp.com';
    
    public function __construct()
    {
        $this->CI = &get_instance();
        $this->CI->load->library('RESTClient');
    }
    
    public function get_user_by_id( $user_id )
    {
        $user = false;
        
        $json = RESTClient::get(self::BASE_URI . "/users/$user_id.json");        

        if ( !empty($json) ) {
            $user = json_decode($json);
        }
        
        return $user;
    }
    
    public function get_user_by_username( $username )
    {
        $user = false;
        
        $json = RESTClient::get(self::BASE_URI . "/users/$username.json");        

        if ( !empty($json) ) {
            $user = json_decode($json);
        }
        
        return $user;
    }
    
    public function get_user_by_facebook_id( $facebook_id )
    {
        $user = false;
        
        $json = RESTClient::get(self::BASE_URI . "/users/facebook/$facebook_id.json");        

        if ( !empty($json) ) {
            $user = json_decode($json);
        }
        
        return $user;
    }
    
    public function add_facebook_user( $facebook_user )
    {        
        $user = false;
        
        if ( $facebook_user ) {            
            $new_user = array(
                'email'             => $facebook_user['email'],
                'facebook_id'       => $facebook_user['id'],
                'facebook_username' => $facebook_user['username'],
                'username'          => $facebook_user['username'],
                'firstname'         => $facebook_user['first_name'],
                'lastname'          => $facebook_user['last_name'],
                'photo_url'         => 'http://graph.facebook.com/' . $facebook_user['id'] . '/picture'
            );
            
            var_dump($new_user);exit;
            
            $json = RESTClient::post(self::BASE_URI . "/users/new.json", $new_user);        

            if ( !empty($json) ) {
                $user = json_decode($json);
            }
        }
        
        return $user;
    }
    
}
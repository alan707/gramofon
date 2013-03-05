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
    
    public function get_users()
    {
        $users = false;
        
        $json = RESTClient::get(self::BASE_URI . "/users.json");        

        if ( !empty($json) ) {
            $users = json_decode($json);
        }
        
        return $users;
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
            
            $json = RESTClient::post(self::BASE_URI . "/users/new.json", $new_user);        

            if ( !empty($json) ) {
                $user = json_decode($json);
            }
        }
        
        return $user;
    }
    
    public function get_audio_clips( $offset = 0, $limit = 20 )
    {
        $audio_clips = array();
                
        $params = array(
            'offset' => $offset,
            'limit'  => $limit
        );
        
        $url = self::BASE_URI . '/audio_clips.json?' . http_build_query($params);
        
        $json = RESTClient::get($url);
        
        if ( !empty($json) ) {
            $audio_clips = json_decode($json);
        }
        
        return $audio_clips;
    }
    
    public function get_user_audio_clips( $user_id, $offset = 0, $limit = 20 )
    {
        $audio_clips = array();
                
        $params = array(
            'offset' => $offset,
            'limit'  => $limit
        );
        
        $url = self::BASE_URI . "/users/$user_id/audio_clips.json?" . http_build_query($params);
        
        $json = RESTClient::get($url);
        
        if ( !empty($json) ) {
            $audio_clips = json_decode($json);
        }
        
        return $audio_clips;
    }
    
    public function get_audio_clip( $id )
    {
        $clip = false;
        
        $json = RESTClient::get(self::BASE_URI . "/audio_clips/$id.json");

        if ( !empty($json) ) {
            $clip = json_decode($json);
        }
        
        return $clip;
    }
    
    
    public function update_audio_clip( $id, $data )
    {
        $clip = false;

        $json = RESTClient::put(self::BASE_URI . "/audio_clips/$id.json", $data);

        if ( !empty($json) ) {
            $clip = json_decode($json);
        }
        
        return $clip;
    }
    
}
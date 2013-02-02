<?php

class Audio_clip_model extends CI_Model {
    
    public function get_all()
    {
        $audio_clips = array();
        
        $json = file_get_contents("http://gramofon.herokuapp.com/audio_clips.json");
        
        if ( !empty($json) ) {
            $audio_clips = json_decode($json);
            
            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
                $clip->updated_at = strtotime($clip->updated_at);
            }
        }
        
        return $audio_clips;
    }
    
    public function get_user_audio_clips( $username )
    {
        $audio_clips = array();
        
        $json = file_get_contents("http://gramofon.herokuapp.com/users/$username/audio_clips.json");
        
        if ( !empty($json) ) {
            $audio_clips = json_decode($json);

            if ( !is_array($audio_clips) ) {
                $audio_clips = array( $audio_clips );
            } 
            
            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
                $clip->updated_at = strtotime($clip->updated_at);
            }
        }
        
        return $audio_clips;
    }
    
}
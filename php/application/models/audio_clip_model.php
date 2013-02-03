<?php

class Audio_clip_model extends CI_Model {
    
    public function get_all()
    {
        $audio_clips = array();
        
        if ( ! OFFLINE_MODE ) {
            $json = @file_get_contents("http://gramofon.herokuapp.com/audio_clips.json");
        }
        
        // offline fallback
        if ( empty($json) ) {
            $json = file_get_contents("http://local.usegramofon.com/json/audio_clips.json");
        }

        if ( !empty($json) ) {
            $audio_clips = json_decode($json);

            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
                $clip->updated_at = strtotime($clip->updated_at);
            }
        }
        
        rsort($audio_clips);
        
        return $audio_clips;
    }
    
    public function get_user_audio_clips( $username )
    {
        $audio_clips = array();
        
        if ( ! OFFLINE_MODE ) {
            $json = file_get_contents("http://gramofon.herokuapp.com/users/$username/audio_clips.json");
        }
        
        // offline fallback
        if ( empty($json) ) {
            $json = file_get_contents("http://local.usegramofon.com/json/audio_clips.json");
        }
        
        if ( !empty($json) ) {
            $audio_clips = json_decode($json);

            if ( !is_array($audio_clips) ) {
                $audio_clips = array( $audio_clips );
            } 
        
            rsort($audio_clips);
            
            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
                $clip->updated_at = strtotime($clip->updated_at);
            }
        }
        
        return $audio_clips;
    }
    
    public function get_audio_clip( $id )
    {
        $audio_clip = false;
        
        if ( ! OFFLINE_MODE ) {
            $json = @file_get_contents("http://gramofon.herokuapp.com/audio_clips/$id.json");
        }
        
        // offline fallback
        if ( empty($json) ) {
            $json = file_get_contents("http://local.usegramofon.com/json/audio_clip.json");
        }

        if ( !empty($json) ) {
            $audio_clip = json_decode($json);
            
            $audio_clip->created_at = strtotime($audio_clip->created_at);
            $audio_clip->updated_at = strtotime($audio_clip->updated_at);
        }
        
        return $audio_clip;
    }
    
}
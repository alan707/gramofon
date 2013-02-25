<?php

class Audio_clip_model extends CI_Model {
    
    public function get_all( $offset = 0, $limit = 20 )
    {
        $audio_clips = $this->gramofonclient->get_audio_clips($offset, $limit);
        
        if ( !empty($audio_clips) ) {            
            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
            }
        }
        
        return $audio_clips;
    }
    
    public function get_user_audio_clips( $username, $offset = 0, $limit = 20 )
    {        
        $audio_clips = $this->gramofonclient->get_user_audio_clips($username, $offset, $limit);
        
        if ( !empty($audio_clips) ) { 
            if ( !is_array($audio_clips) ) {
                $audio_clips = array( $audio_clips );
            } 
            
            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
            }
        }
        
        return $audio_clips;
    }
    
    public function get_audio_clip( $id )
    {
        $clip = $this->gramofonclient->get_audio_clip($id);
        
        if ( !empty($clip) ) {             
            $clip->created_at = strtotime($clip->created_at);
        }
        
        return $clip;
    }
    
    
    public function update_audio_clip( $id, $data )
    {
        $clip = $this->gramofonclient->update_audio_clip($id, $data );
        
        return $clip;
    }
    
}
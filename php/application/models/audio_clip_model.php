<?php

class Audio_clip_model extends CI_Model {
    
    public function get_all()
    {
        $audio_clips = $this->gramofonclient->get_audio_clips();
        
        if ( !empty($audio_clips) ) {            
            $audio_clips = array_slice($audio_clips, 20);

            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
                $clip->updated_at = strtotime($clip->updated_at);
            }
        }
        
        // @todo: remove when order of clips is reversed in API
        rsort($audio_clips);
        
        return $audio_clips;
    }
    
    public function get_user_audio_clips( $username )
    {        
        $audio_clips = $this->gramofonclient->get_user_audio_clips($username);
        
        if ( !empty($audio_clips) ) { 
            if ( !is_array($audio_clips) ) {
                $audio_clips = array( $audio_clips );
            } 
        
            // @todo: remove when order of clips is reversed in API
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
        $clip = $this->gramofonclient->get_audio_clip($id);
        
        if ( !empty($clip) ) {             
            $clip->created_at = strtotime($clip->created_at);
            $clip->updated_at = strtotime($clip->updated_at);
        }
        
        return $clip;
    }
    
    
    public function update_audio_clip( $id, $data )
    {
        $clip = $this->gramofonclient->update_audio_clip($id, $data );
        
        return $clip;
    }
    
}
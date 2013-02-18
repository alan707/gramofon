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
            
            $audio_clips = array_slice($audio_clips, 20);

            foreach ( $audio_clips as &$clip ) {
                $clip->created_at = strtotime($clip->created_at);
                $clip->updated_at = strtotime($clip->updated_at);
                
                // fake in user photos until we have real user photos
                $user_photo = $this->_add_user_photo($clip->username);
                
                if ( $user_photo ) {
                    $clip->photo = $user_photo;
                }
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
                
                // fake in user photos until we have real user photos
                $user_photo = $this->_add_user_photo($clip->username);

                if ( $user_photo ) {
                    $clip->photo = $user_photo;
                }
            }
        }
        
        return $audio_clips;
    }
    
    public function get_audio_clip( $id )
    {
        $clip = false;
        
        if ( ! OFFLINE_MODE ) {
            $json = @file_get_contents("http://gramofon.herokuapp.com/audio_clips/$id.json");
        }
        
        // offline fallback
        if ( empty($json) ) {
            $json = file_get_contents("http://local.usegramofon.com/json/audio_clip.json");
        }

        if ( !empty($json) ) {
            $clip = json_decode($json);
            
            $clip->created_at = strtotime($clip->created_at);
            $clip->updated_at = strtotime($clip->updated_at);
                
            // fake in user photos until we have real user photos
            $user_photo = $this->_add_user_photo($clip->username);

            if ( $user_photo ) {
                $clip->photo = $user_photo;
            }
        }
        
        return $clip;
    }
    
    private function _add_user_photo( $username )
    {
        $user_photo = '/images/user-photo.jpg';
        
        $user_photos = array(
            'amond'    => 'http://profile.ak.fbcdn.net/hprofile-ak-ash3/s200x200/530565_10102950454612124_1281285938_n.jpg',
            'benchutz' => 'http://profile.ak.fbcdn.net/hprofile-ak-ash3/s200x200/525896_10102292859862274_1574279843_n.jpg',
            'dtrenz'   => 'http://profile.ak.fbcdn.net/hprofile-ak-ash4/s200x200/293575_10151404780873832_883004756_n.jpg',
            'raul'     => 'http://profile.ak.fbcdn.net/hprofile-ak-snc6/168690_490367046461_326319_n.jpg',
            'Chris'    => 'http://profile.ak.fbcdn.net/hprofile-ak-ash4/s320x320/407312_10100531205646645_182024679_n.jpg',
            'eflatt'   => 'http://profile.ak.fbcdn.net/hprofile-ak-prn1/s200x200/644295_10151468936365628_594630485_n.jpg'
        );
        
        if ( isset($user_photos[$username]) ) {
            $user_photo = $user_photos[$username];
        }
        
        return $user_photo;
    }
    
}
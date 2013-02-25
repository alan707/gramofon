<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Utilities extends CI_Controller {

    public function link_audio_clips()
    {
        $this->load->model('user_model');
        $this->load->model('audio_clip_model');
        
        $users = $this->user_model->get_users();
        
        foreach ( $users as $user ) {
            $clips = $this->audio_clip_model->get_user_audio_clips($user->username);
            
            if ( !empty($clips) ) {
                foreach ( $clips as $clip ) {
                    if ( empty($clip->user_id) ) {
                        $data = array( 'audio_clip' => array( 'user_id' => $user->id ) );
                        $updated_clip = $this->audio_clip_model->update_audio_clip($clip->id, $data);
                        die;
                    }
                }
            }
        }
    }

}
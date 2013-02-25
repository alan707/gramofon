<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Audio_clip extends CI_Controller {

    public function index( $id )
    {
        $this->load->model('audio_clip_model');
        
        $audio_clip = $this->audio_clip_model->get_audio_clip($id);
        
        if ( empty($audio_clip) ) {
            show_404();
        }

        $data = array(
            'me' => $this->session->userdata('user'),
            'audio_clip' => $audio_clip
        );
        
        $this->load->view('audio-clip', $data);
    }

    public function increment_play_count( $id )
    {
        $return = false;
        
        $this->load->model('audio_clip_model');
        
        $audio_clip = $this->audio_clip_model->get_audio_clip($id);

        if ( $audio_clip ) {
            $play_count = ( $audio_clip->play_count ) ? $audio_clip->play_count : 0;
            $return = $this->audio_clip_model->update_audio_clip($id, array( 'play_count' => $play_count + 1 ));
        }
        
        echo(json_encode($return));
    }
    
//    public function like( $id )
//    {
//        $return = false;
//        
//        $this->load->model('audio_clip_model');
//        
//        $audio_clip = $this->audio_clip_model->get_audio_clip($id);
//        
//        if ( isset($audio_clip->like_count) ) {
//            $return = $this->audio_clip_model->update_audio_clip($id, array( 'like_count' => $audio_clip->like_count + 1 ));
//        }
//        
//        echo(json_encode($return));
//    }
//    
//    public function unlike( $id )
//    {
//        $return = false;
//        
//        $this->load->model('audio_clip_model');
//        
//        $audio_clip = $this->audio_clip_model->get_audio_clip($id);
//        
//        if ( $audio_clip ) {
//            $return = $this->audio_clip_model->update_audio_clip($id, array( 'like_count' => $audio_clip->like_count - 1 ));
//        }
//        
//        echo(json_encode($return));
//    }

}
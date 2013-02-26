<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Home extends CI_Controller {
    
    public function index()
    {
        $this->load->model('audio_clip_model');
        
        $audio_clips = $this->audio_clip_model->get_all(0, 20);
        
        $data = array(
            'me' => $this->session->userdata('user'),
            'audio_clips' => $audio_clips
        );
        
        $this->load->view('home', $data);
    }
    
    public function ajax_pagination( $offset = 0, $limit = 0 )
    {
        $this->load->model('audio_clip_model');
        
        $audio_clips = $this->audio_clip_model->get_all($offset, $limit);
        
        if ( !empty($audio_clips) ) {
            foreach ( $audio_clips as $clip ) {
                $this->load->view('global/audio-clip.php', array( 'clip' => $clip ));
            }
        }
    }

}
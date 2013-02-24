<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Audio_clip extends CI_Controller {

    public function index( $id )
    {
        $this->load->model('audio_clip_model');
        
        $audio_clip = $this->audio_clip_model->get_audio_clip($id);

        $data = array(
            'me' => $this->session->userdata('user'),
            'audio_clip' => $audio_clip
        );
        
        $this->load->view('audio-clip', $data);
    }

    public function increment_play_count( $id )
    {
        $this->load->model('audio_clip_model');
        
        $audio_clip = $this->audio_clip_model->get_audio_clip($id);

        $data = array(
            'me' => $this->session->userdata('user'),
            'audio_clip' => $audio_clip
        );
        
        $this->load->view('audio-clip', $data);
    }

}
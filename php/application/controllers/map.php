<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Map extends CI_Controller {

    public function index(  )
    {
        $this->load->model('audio_clip_model');

        $audio_clips = $this->audio_clip_model->get_all();

        $data = array(
            'audio_clips' => $audio_clips
        );

        $this->load->view('map', $data);
    }   

}
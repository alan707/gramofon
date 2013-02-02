<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Home extends CI_Controller {

    public function index()
    {
//        $this->load->model('audio_model');
//        
//        $audio_clips = $this->audio_model->get_audio_clips();
        
        $this->load->view('home');
    }

}
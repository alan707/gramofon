<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class Audio_clip extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        // Your own constructor code
        $CI = & get_instance();
        $CI->config->load("facebook",TRUE);
        $config = $CI->config->item('facebook');
        $this->load->library('facebook', $config);
    }

    public function index( $id )
    {
        $this->load->model('audio_clip_model');
        
        $audio_clip = $this->audio_clip_model->get_audio_clip($id);

        $data = array(
            'audio_clip' => $audio_clip
        );
        
        $this->load->view('audio-clip', $data);
    }

}
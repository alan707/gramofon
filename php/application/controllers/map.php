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

    public function user($username){
        $this->load->model('user_model');

        $user = $this->user_model->get_user_profile($username);

        if ( $user ) {
            $this->load->model('audio_clip_model');

            $user->audio_clips = $this->audio_clip_model->get_user_audio_clips($username);

            //4sq API: https://api.foursquare.com/v2/venues/search?ll=lat,long&intet=match&llAcc=1&&oauth_token=#####
        } else {
            show_404();
        }

        $data = array(
            'user' => $user
        );

        $this->load->view('user-map', $data);
    }

}
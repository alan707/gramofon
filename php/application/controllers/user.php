<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class User extends CI_Controller {

    public function __construct()
    {
        parent::__construct();
        // Your own constructor code
        $CI = & get_instance();
        $CI->config->load("facebook",TRUE);
        $config = $CI->config->item('facebook');
        $this->load->library('facebook', $config);
    }

    public function index( $username )
    {
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
        
        $this->load->view('user', $data);
    }   

    public function facebook()
    {
        $user = $this->facebook->getUser();
        print_r($this->facebook);
        if($user) {
            try {
                $user_info = $this->facebook->api('/me');
                echo '<pre>'.htmlspecialchars(print_r($user_info, true)).'</pre>';
            } catch(FacebookApiException $e) {
                echo '<pre>'.htmlspecialchars(print_r($e, true)).'</pre>';
                $user = null;
            }
        } else {
            echo "<a href=\"{$this->facebook->getLoginUrl()}\">Login using Facebook!</a>";
        }
    }

}
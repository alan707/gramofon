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
        
    // Stop cache
    $CI->output->set_header("Cache-Control: private, no-store, no-cache, must-revalidate, post-check=0, pre-check=0");
    $CI->output->set_header("Pragma: no-cache");


    // Repopulate _REQUEST ... Facebook needs it.
    $request_uri = $_SERVER['REQUEST_URI'];
    $request_uri = explode('?',$request_uri);
    if(count($request_uri) > 1) {
        parse_str($request_uri[1], $_REQUEST);
    }
        
        
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
        
        echo "User ID: " . $user;
        
        if($user) {
            try {
                $user_info = $this->facebook->api('/me');
                echo '<pre>'.htmlspecialchars(print_r($user_info, true)).'</pre>';
                echo "<br/><br/><a href=\"{$this->facebook->getLogoutUrl()}\">Logout of Facebook!</a>";
            } catch(FacebookApiException $e) {
                echo '<pre>'.htmlspecialchars(print_r($e, true)).'</pre>';
                $user = null;
            }
        } else {
            echo "<a href=\"{$this->facebook->getLoginUrl()}\">Login using Facebook!</a>";
        }
        
        
    }

}
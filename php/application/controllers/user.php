<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class User extends CI_Controller {
    
    public function index( $username )
    {
        $this->load->model('user_model');
        
        $user = $this->user_model->get_user_profile($username);
        
        if ( $user ) {
            $this->load->model('audio_clip_model');
            
            $user->audio_clips = $this->audio_clip_model->get_user_audio_clips($username);
        } else {
            show_404();
        }
        
        $data = array( 
            'user'       => $user,
            'clip_count' => count($user->audio_clips)
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

                echo "<img src='https://graph.facebook.com/" . $user_info['username'] . "/picture?type=normal' />";                 

            } catch(FacebookApiException $e) {
                echo '<pre>'.htmlspecialchars(print_r($e, true)).'</pre>';
                $user = null;
            }
        } else {
            echo "<a href=\"{$this->facebook->getLoginUrl()}\">Login using Facebook!</a>";
        }
    }

}
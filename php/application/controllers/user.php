<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class User extends CI_Controller {
    
    public function index( $username )
    {
        $this->load->model('user_model');
        
        $user = $this->user_model->get_user_profile($username);
        
        if ( $user ) {
            $this->load->model('audio_clip_model');
            
            $user->audio_clips = $this->audio_clip_model->get_user_audio_clips($user->id, 0, 5);
            $user->clip_count  = count($user->audio_clips);
        } else {
            show_404();
        }
        
        $data = array( 
            'me' => $this->session->userdata('user'),
            'user' => $user
        );
        
        $this->load->view('user', $data);
    }
    
    public function logout()
    {
        $this->session->set_userdata('user', 0);
                
        $this->input->set_cookie(array(
            'name'   => 'remember',
            'expire' => ''
        ));

        redirect('/');
    }

}
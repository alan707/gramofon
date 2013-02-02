<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

class User extends CI_Controller {

    public function index( $username )
    {
        $this->load->model('user_model');
        
        $user = $this->user_model->get_user_profile($username);
        
        $this->load->view('user', array( 'user' => $user ));
    }

}
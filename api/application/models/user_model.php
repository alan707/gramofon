<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class user_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('User');
    }

    public function get_all_users( $offset = 0, $limit = 10 )
    {
        $users = array();

        $users[] = new User;
        $users[] = new User;
        $users[] = new User;
        $users[] = new User;
        $users[] = new User;

        return $users;
    }

    public function get_user( $id, $id_type )
    {
        $user = FALSE;

        if ( $id_type !== 'facebook' ) {
            $user = new User;
        } else {            
            $user = new User;
        }

        return $user;
    }

    public function create_user( $data )
    {
        $user = new User;

        $user->id          = 1;
        $user->username    = $data['username'];
        $user->first_name  = $data['first_name'];
        $user->last_name   = $data['last_name'];
        $user->email       = $data['email'];
        $user->facebook_id = $data['facebook_id'];

        return $user;
    }

    public function update_user( $id, $data )
    {
        $user = new User;
        
        $user->id = $id;

        foreach ( $data as $key => $value ) {
            if ( property_exists('User', $key) ) {
                $user->$key = $value;
            }
        }

        return $user;
    }

    public function remove_user( $id )
    {
        return TRUE;
    }

}
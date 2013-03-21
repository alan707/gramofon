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
        
        $query = $this->db->get( 'users', $limit, $offset );

        foreach ( $query->result() as $user ) {
            $users[] = $user;
        }

        return $users;
    }

    public function get_user( $id, $id_type = null )
    {
        $user = FALSE;

        if ( $id_type === 'facebook' ) {
            $query = $this->db->get_where( 'users', array('facebook_id' => $id) );
        } else {            
            $query = $this->db->get_where( 'users', array('id' => $id) );
        }

        if ( $query->num_rows() > 0 ) {
            $user = $query->row();
        }

        return $user;
    }

    public function create_user( $data )
    {
        // @todo: add errors

        $user = new stdClass;
        $user->username    = $data['username'];
        $user->first_name  = $data['first_name'];
        $user->last_name   = $data['last_name'];
        $user->email       = $data['email'];
        $user->facebook_id = $data['facebook_id'];

        $this->db->insert( 'users', $user );

        $new_user_id = $this->db->insert_id();

        if ( $new_user_id ) {
            $new_user = $this->get_user( $new_user_id );
        }

        return $user;
    }

    // @todo
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
        $this->db->delete( 'users', array('id' => $id) );

        $query = $this->db->get_where( 'users', array('id' => $id) );

        return ( $query->num_rows() == 0 );
    }

    // @todo
    public function get_all_liked_clips( $offset = 0, $limit = 10 )
    {
        $users = array();

        $users[] = new User;
        $users[] = new User;
        $users[] = new User;
        $users[] = new User;
        $users[] = new User;

        return $users;
    }

}
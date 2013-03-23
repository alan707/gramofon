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

        $this->db->select(
            'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $query = $this->db->get( 'users', $limit, $offset );

        foreach ( $query->result() as $user ) {
            $users[] = new User( $user );
        }

        return $users;
    }

    public function get_user( $id, $id_type = null )
    {
        $user = FALSE;

        $this->db->select(
            'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        if ( $id_type === 'facebook' ) {
            $query = $this->db->get_where( 'users', array('facebook_id' => $id) );
        } elseif ( $id_type == 'username' ) {            
            $query = $this->db->get_where( 'users', array('username' => $id) );
        } else {            
            $query = $this->db->get_where( 'users', array('id' => $id) );
        }

        if ( $query->num_rows() > 0 ) {
            $user = new User( $query->row() );
        }

        return $user;
    }

    public function create_user( $data )
    {
        // @todo: add errors

        $user = new stdClass;
        $user->username    = $data['username'];
        $user->firstname   = $data['firstname'];
        $user->lastname    = $data['lastname'];
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
    // public function update_user( $id, $data )
    // {
    //     $user = new User;
        
    //     $user->id = $id;

    //     foreach ( $data as $key => $value ) {
    //         if ( property_exists('User', $key) ) {
    //             $user->$key = $value;
    //         }
    //     }

    //     return $user;
    // }

    public function remove_user( $id )
    {
        $this->db->delete( 'users', array('id' => $id) );

        $query = $this->db->get_where( 'users', array('id' => $id) );

        return ( $query->num_rows() == 0 );
    }

    // @todo
    // public function get_all_liked_clips( $offset = 0, $limit = 10 )
    // {
    //     $users = array();

    //     $users[] = new User;
    //     $users[] = new User;
    //     $users[] = new User;
    //     $users[] = new User;
    //     $users[] = new User;

    //     return $users;
    // }

}
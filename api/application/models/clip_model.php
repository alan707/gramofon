<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('Clip');
        $this->load->library('User');
    }

    public function get_all_clips( $offset = 0, $limit = 10 )
    {
        $clips = array();

        $this->db->select(
            'clips.*,'
          . 'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'clips.user_id = users.id' );
        $this->db->order_by( 'clips.created', 'desc');

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $row ) {
            $clips[] = new Clip( $row );
        }

        return $clips;
    }

    public function get_all_user_clips( $user_id, $offset = 0, $limit = 10 )
    {
        $clips = array();

        $this->db->select(
            'clips.*,'
          . 'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'clips.user_id = users.id' );
        $this->db->where( 'user_id', $user_id );
        $this->db->order_by( 'clips.created', 'desc');

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $row ) {
            $clips[] = new Clip( $row );
        }

        return $clips;
    }

    public function get_clip( $id )
    {
        $clip = new stdClass;

        $this->db->select(
            'clips.*,'
          . 'users.id as user_id,'
          . 'users.username as user_username,'
          . 'users.firstname as user_firstname,'
          . 'users.lastname as user_lastname,'
          . 'users.email as user_email,'
          . 'users.facebook_id as user_facebook_id,'
          . 'users.created as user_created'
        );

        $this->db->join( 'users', 'clips.user_id = users.id' );

        $query = $this->db->get_where( 'clips', array('clips.id' => $id) );

        if ( $query->num_rows() > 0 ) {
            $clip = new Clip( $query->row() );
        }

        return $clip;
    }

    public function create_clip( $data )
    {
        $new_clip = new stdClass;

        // @todo: upload file data to S3
        // @todo: add errors

        $clip = new stdClass;
        $clip->filename  = $data['filename'];
        $clip->title     = $data['title'];
        $clip->latitude  = $data['latitude'];
        $clip->longitude = $data['longitude'];
        $clip->venue     = $data['venue'];
        $clip->user_id   = $data['user_id'];

        $this->db->insert( 'clips', $clip );

        $new_clip_id = $this->db->insert_id();

        if ( $new_clip_id ) {
            $new_clip = $this->get_clip( $new_clip_id );
        }

        return $new_clip;
    }

    // @todo
    // public function update_clip( $id, $data )
    // {
    //     $clip = new stdClass;

    //     $clip->id = $id;

    //     foreach ( $data as $key => $value ) {
    //         if ( property_exists('Clip', $key) ) {
    //             $clip->$key = $value;
    //         }
    //     }

    //     return $clip;
    // }

    public function remove_clip( $id )
    {
        $this->db->delete( 'clips', array('id' => $id) );

        $query = $this->db->get_where( 'clips', array('id' => $id) );

        return ( $query->num_rows() == 0 );
    }

}
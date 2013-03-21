<?php if ( ! defined('BASEPATH') ) exit('No direct script access allowed');

class Clip_model extends CI_Model
{

    public function __construct()
    {
        parent::__construct();

        $this->load->library('Clip');
    }

    public function get_all_clips( $offset = 0, $limit = 10 )
    {
        $clips = array();

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $clip ) {
            $clips[] = $clip;
        }

        return $clips;
    }

    public function get_all_user_clips( $user_id, $offset = 0, $limit = 10 )
    {
        $clips = array();

        $this->db->where( 'user_id', $user_id );

        $query = $this->db->get( 'clips', $limit, $offset );

        foreach ( $query->result() as $clip ) {
            $clips[] = $clip;
        }

        return $clips;
    }

    public function get_clip( $id )
    {
        $clip = new stdClass;

        $this->db->join( 'users', 'clips.user_id = users.user_id' );

        $query = $this->db->get_where( 'clips', array('id' => $id) );

        if ( $query->num_rows() > 0 ) {
            $clip = $query->row();
        }

        return $clip;
    }

    public function create_clip( $data )
    {
        $new_clip = stdClass;

        // @todo: upload file data to S3
        // @todo: add errors

        $clip = new stdClass;
        $clip->title     = $data['title'];
        $clip->user_id   = $data['user_id'];
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
    public function update_clip( $id, $data )
    {
        $clip = new stdClass;

        $clip->id = $id;

        foreach ( $data as $key => $value ) {
            if ( property_exists('Clip', $key) ) {
                $clip->$key = $value;
            }
        }

        return $clip;
    }

    public function remove_clip( $id )
    {
        $this->db->delete( 'clips', array('id' => $id) );

        $query = $this->db->get_where( 'clips', array('id' => $id) );

        return ( $query->num_rows() == 0 );
    }

}